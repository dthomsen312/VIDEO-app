import AVFoundation
import Combine
import UIKit

/// Owns the capture session and the repeating clip schedule.
///
/// Schedule shape: tap Start and clip 1 begins immediately. Each clip runs for
/// `clipDuration` seconds, then the camera sits idle (preview still live) until
/// the next `cycleInterval` boundary measured from the moment Start was tapped.
/// Boundaries come off a fixed anchor date rather than chained timers, so a
/// slow tick never accumulates drift over a long session.
@MainActor
final class RecordingController: NSObject, ObservableObject {

    enum SessionState: Equatable {
        case idle
        case waiting
        case recording
    }

    // MARK: - Tunables

    /// How long each clip runs.
    static let clipDuration: TimeInterval = 10

    /// Time from the start of one clip to the start of the next.
    static let cycleInterval: TimeInterval = 120

    /// Warn if the phone has less than this much room when a session starts.
    private static let lowSpaceThreshold: Int64 = 500 * 1024 * 1024

    // MARK: - Published state

    @Published private(set) var state: SessionState = .idle
    /// Seconds left in the current clip, or seconds until the next one starts.
    @Published private(set) var countdown: Int = 0
    @Published private(set) var clipsThisSession: Int = 0
    @Published private(set) var lastClipName: String?
    @Published private(set) var isReady = false
    @Published var message: String?

    // MARK: - Capture

    let captureSession = AVCaptureSession()
    private let movieOutput = AVCaptureMovieFileOutput()
    private let sessionQueue = DispatchQueue(label: "com.handsfreerecorder.session")
    private var hasConfigured = false

    // MARK: - Scheduling

    private var tickTimer: Timer?
    private var anchor: Date?
    private var nextClipIndex = 0
    private var currentClipEnd: Date?

    /// True from the moment `startRecording` is dispatched until the delegate
    /// reports the file is finalized. `stopRecording` returns long before the
    /// file is closed, so without this a fast Stop→Start could ask the output to
    /// record while it's still writing the previous clip.
    private var outputBusy = false

    private var observers: [NSObjectProtocol] = []

    override init() {
        super.init()

        let center = NotificationCenter.default

        observers.append(center.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            Task { @MainActor in self?.handleDidEnterBackground() }
        })

        // Runtime errors arrive on an arbitrary queue, so pull the text out here
        // and hop to the main actor with a plain String.
        observers.append(center.addObserver(
            forName: AVCaptureSession.runtimeErrorNotification,
            object: captureSession,
            queue: nil
        ) { [weak self] note in
            let error = note.userInfo?[AVCaptureSessionErrorKey] as? NSError
            let text = error?.localizedDescription ?? "unknown error"
            Task { @MainActor in self?.handleRuntimeError(text) }
        })
    }

    deinit {
        for observer in observers {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    // MARK: - Setup

    /// Asks for camera and microphone access, then wires up and starts the
    /// preview. Safe to call more than once.
    func prepare() async {
        guard !hasConfigured else { return }

        let cameraGranted = await Self.requestAccess(for: .video)
        guard cameraGranted else {
            message = "VIDEO needs camera access. Enable it in Settings › Privacy & Security › Camera."
            return
        }

        let micGranted = await Self.requestAccess(for: .audio)
        if !micGranted {
            message = "Microphone access is off, so clips will be silent. Enable it in Settings if you want sound."
        }

        hasConfigured = true
        configureSession(includeAudio: micGranted)
    }

    private static func requestAccess(for mediaType: AVMediaType) async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: mediaType) {
        case .authorized: return true
        case .notDetermined: return await AVCaptureDevice.requestAccess(for: mediaType)
        default: return false
        }
    }

    private func configureSession(includeAudio: Bool) {
        let session = captureSession
        let output = movieOutput

        sessionQueue.async { [weak self] in
            session.beginConfiguration()
            session.sessionPreset = .high

            var failure: String?

            if let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
               let input = try? AVCaptureDeviceInput(device: camera),
               session.canAddInput(input) {
                session.addInput(input)
            } else {
                failure = "Couldn't open the back camera on this device."
            }

            if includeAudio,
               let mic = AVCaptureDevice.default(for: .audio),
               let micInput = try? AVCaptureDeviceInput(device: mic),
               session.canAddInput(micInput) {
                session.addInput(micInput)
            }

            if session.canAddOutput(output) {
                session.addOutput(output)
            } else if failure == nil {
                failure = "Couldn't set up the movie recorder."
            }

            session.commitConfiguration()

            if let connection = output.connection(with: .video) {
                // The UI is portrait-locked, so pin the recorded orientation to match.
                if connection.isVideoRotationAngleSupported(90) {
                    connection.videoRotationAngle = 90
                }
                if connection.isVideoStabilizationSupported {
                    connection.preferredVideoStabilizationMode = .auto
                }
            }

            if failure == nil {
                session.startRunning()
            }

            let result = failure
            Task { @MainActor in
                guard let self else { return }
                if let result {
                    self.message = result
                } else {
                    self.isReady = true
                }
            }
        }
    }

    // MARK: - Session control

    func start() {
        guard state == .idle else { return }
        guard isReady else {
            message = "Camera isn't ready yet — give it a second."
            return
        }

        if let free = ClipStorage.availableBytes, free < Self.lowSpaceThreshold {
            let mb = free / (1024 * 1024)
            message = "Only \(mb) MB of storage left. Clear some space before a long session."
        }

        anchor = Date()
        nextClipIndex = 0
        clipsThisSession = 0
        state = .waiting
        countdown = 0
        UIApplication.shared.isIdleTimerDisabled = true
        startTicking()
        tick() // clip 1 is due immediately
    }

    func stop() {
        guard state != .idle else { return }
        state = .idle
        countdown = 0
        anchor = nil
        currentClipEnd = nil
        stopTicking()
        UIApplication.shared.isIdleTimerDisabled = false

        let output = movieOutput
        sessionQueue.async {
            if output.isRecording {
                // The partial clip still gets written and saved.
                output.stopRecording()
            }
        }
    }

    // MARK: - Ticking

    private func startTicking() {
        stopTicking()
        let timer = Timer(timeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
        // .common keeps the countdown alive while the user is touching the screen.
        RunLoop.main.add(timer, forMode: .common)
        tickTimer = timer
    }

    private func stopTicking() {
        tickTimer?.invalidate()
        tickTimer = nil
    }

    private func tick() {
        let now = Date()

        switch state {
        case .idle:
            break

        case .recording:
            guard let end = currentClipEnd else { return }
            setCountdown(Int(ceil(end.timeIntervalSince(now))))
            // AVFoundation stops the clip itself at maxRecordedDuration. This is
            // only a backstop in case that never lands.
            if now.timeIntervalSince(end) > 1.5 {
                let output = movieOutput
                sessionQueue.async {
                    if output.isRecording { output.stopRecording() }
                }
            }

        case .waiting:
            guard let anchor else { return }
            let due = anchor.addingTimeInterval(Double(nextClipIndex) * Self.cycleInterval)
            if now >= due {
                beginClip()
            } else {
                setCountdown(Int(ceil(due.timeIntervalSince(now))))
            }
        }
    }

    /// The tick runs 10x a second but the dial only shows whole seconds — skip
    /// the redundant publishes so SwiftUI isn't re-rendering constantly for hours.
    private func setCountdown(_ seconds: Int) {
        let clamped = max(0, seconds)
        if countdown != clamped { countdown = clamped }
    }

    // MARK: - Clips

    private func beginClip() {
        guard state == .waiting else { return }
        // Still closing out the previous file — the next tick will try again.
        guard !outputBusy else { return }

        let url: URL
        do {
            url = try ClipStorage.newClipURL()
        } catch {
            message = "Couldn't create the clip file: \(error.localizedDescription)"
            stop()
            return
        }

        state = .recording
        outputBusy = true
        currentClipEnd = Date().addingTimeInterval(Self.clipDuration)
        countdown = Int(Self.clipDuration)
        nextClipIndex += 1

        let output = movieOutput
        let duration = Self.clipDuration
        sessionQueue.async { [weak self] in
            guard let self else { return }
            output.maxRecordedDuration = CMTime(seconds: duration, preferredTimescale: 600)
            output.startRecording(to: url, recordingDelegate: self)
        }
    }

    private func finishClip(url: URL, succeeded: Bool, errorText: String?) {
        currentClipEnd = nil
        outputBusy = false

        if succeeded {
            clipsThisSession += 1
            lastClipName = url.lastPathComponent
        } else {
            try? FileManager.default.removeItem(at: url)
            message = errorText ?? "A clip failed to save."
        }

        // If Stop was tapped mid-clip we're already idle — leave it that way.
        guard state == .recording else { return }
        state = .waiting
        tick()
    }

    // MARK: - Notifications

    private func handleDidEnterBackground() {
        guard state != .idle else { return }
        stop()
        message = "Recording stopped because VIDEO left the screen. Keep it open while you paint."
    }

    private func handleRuntimeError(_ text: String) {
        message = "The camera hit an error: \(text). Tap Start to try again."
        stop()

        let session = captureSession
        sessionQueue.async {
            if !session.isRunning { session.startRunning() }
        }
    }
}

// MARK: - AVCaptureFileOutputRecordingDelegate

extension RecordingController: AVCaptureFileOutputRecordingDelegate {

    nonisolated func fileOutput(_ output: AVCaptureFileOutput,
                                didFinishRecordingTo outputFileURL: URL,
                                from connections: [AVCaptureConnection],
                                error: Error?) {
        // Hitting maxRecordedDuration reports an error even though the file is
        // complete and good — AVErrorRecordingSuccessfullyFinishedKey tells them apart.
        var succeeded = true
        var errorText: String?

        if let error = error as NSError? {
            succeeded = (error.userInfo[AVErrorRecordingSuccessfullyFinishedKey] as? Bool) ?? false
            if !succeeded { errorText = error.localizedDescription }
        }

        let finalSucceeded = succeeded
        let finalErrorText = errorText
        Task { @MainActor in
            self.finishClip(url: outputFileURL, succeeded: finalSucceeded, errorText: finalErrorText)
        }
    }
}
