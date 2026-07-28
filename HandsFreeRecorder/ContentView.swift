import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var controller: RecordingController

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            CameraPreview(session: controller.captureSession)
                .ignoresSafeArea()

            // A thick red frame while recording, readable from across the room.
            if controller.state == .recording {
                Rectangle()
                    .strokeBorder(Color.red, lineWidth: 10)
                    .ignoresSafeArea()
            }

            VStack(spacing: 0) {
                statusHeader
                Spacer()
                countdownDial
                Spacer()
                footer
                controls
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .task { await controller.prepare() }
        .alert("Heads up",
               isPresented: Binding(get: { controller.message != nil },
                                    set: { if !$0 { controller.message = nil } })) {
            Button("OK") { controller.message = nil }
        } message: {
            Text(controller.message ?? "")
        }
    }

    // MARK: - Pieces

    private var statusHeader: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(statusColor)
                .frame(width: 18, height: 18)
            Text(statusText)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(.black.opacity(0.55), in: Capsule())
        .padding(.top, 8)
    }

    private var countdownDial: some View {
        VStack(spacing: 2) {
            Text(controller.state == .idle ? "--" : timeString(controller.countdown))
                .font(.system(size: 96, weight: .heavy, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(controller.state == .recording ? .red : .white)
            Text(dialCaption)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.85))
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 18)
        .background(.black.opacity(0.5), in: RoundedRectangle(cornerRadius: 28))
    }

    private var footer: some View {
        VStack(spacing: 4) {
            Text("\(controller.clipsThisSession) clip\(controller.clipsThisSession == 1 ? "" : "s") this session")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
            Text(controller.lastClipName ?? "Saved to Files › On My iPhone › VIDEO › Recordings")
                .font(.system(size: 13, weight: .regular, design: .monospaced))
                .foregroundStyle(.white.opacity(0.7))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(.black.opacity(0.5), in: RoundedRectangle(cornerRadius: 18))
        .padding(.bottom, 14)
    }

    private var controls: some View {
        HStack(spacing: 14) {
            BigButton(title: "START",
                      systemImage: "play.fill",
                      tint: .green,
                      isEnabled: controller.state == .idle && controller.isReady) {
                controller.start()
            }

            BigButton(title: "STOP",
                      systemImage: "stop.fill",
                      tint: .red,
                      isEnabled: controller.state != .idle) {
                controller.stop()
            }
        }
    }

    // MARK: - Formatting

    private var statusText: String {
        switch controller.state {
        case .idle: return controller.isReady ? "Ready" : "Starting camera…"
        case .waiting: return "Waiting"
        case .recording: return "Recording"
        }
    }

    private var statusColor: Color {
        switch controller.state {
        case .idle: return controller.isReady ? .white : .gray
        case .waiting: return .yellow
        case .recording: return .red
        }
    }

    private var dialCaption: String {
        switch controller.state {
        case .idle:
            let clip = Int(RecordingController.clipDuration)
            let minutes = Int(RecordingController.cycleInterval / 60)
            return "\(clip)s clip every \(minutes) min"
        case .waiting:
            return "until next clip"
        case .recording:
            return "seconds left in clip"
        }
    }

    private func timeString(_ seconds: Int) -> String {
        seconds >= 60
            ? String(format: "%d:%02d", seconds / 60, seconds % 60)
            : "\(seconds)"
    }
}

/// A deliberately oversized, high-contrast target — meant to be hit with a
/// knuckle or the back of a wrist without looking too closely.
private struct BigButton: View {
    let title: String
    let systemImage: String
    let tint: Color
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 44, weight: .bold))
                Text(title)
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(tint.opacity(isEnabled ? 1.0 : 0.25),
                        in: RoundedRectangle(cornerRadius: 26))
        }
        .disabled(!isEnabled)
        .accessibilityLabel(title)
    }
}

#Preview {
    ContentView()
        .environmentObject(RecordingController())
}
