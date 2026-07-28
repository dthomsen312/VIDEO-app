# VIDEO — hands-free interval recorder for iPhone

A single-purpose iPhone app for filming yourself while you work. Tap **START**,
prop the phone up, and it records a **10-second clip every 2 minutes** until you
tap **STOP**. Between clips the camera sits idle with a live preview, so nothing
is being written and the battery isn't burning through a full-length recording.

You touch the phone twice per session: once to start, once to stop.

## Building it

Requires a Mac with Xcode 16 or newer, and an iPhone running iOS 17 or newer.
The camera doesn't work in the Simulator, so run it on a real device.

1. Open `HandsFreeRecorder.xcodeproj`.
2. Select the **VIDEO** target → **Signing & Capabilities** → set **Team** to
   your own Apple ID. Change the bundle identifier from
   `com.example.HandsFreeRecorder` to something unique to you.
3. Pick your iPhone as the run destination and hit ⌘R.
4. Approve the camera and microphone prompts on first launch.

With a free Apple ID the app expires after 7 days and needs a re-install; a paid
developer account extends that to a year.

## Using it

| Screen element | Meaning |
| --- | --- |
| White dot / "Ready" | Camera is live, nothing is being recorded |
| Yellow dot / "Waiting" | Session running, counting down to the next clip |
| Red dot + red frame | Currently recording |
| Big number | Seconds left in the clip, or time until the next one |

The screen is kept awake for the whole session, so set your phone somewhere it
won't overheat and keep it plugged in for long sessions.

## Where the clips go

Each clip is written to `Documents/Recordings` inside the app, named with the
date and time it started:

```
Clip_2026-07-28_14-32-05.mov
Clip_2026-07-28_14-34-05.mov
Clip_2026-07-28_14-36-05.mov
```

To get them off the phone, open **Files → On My iPhone → VIDEO → Recordings**.
From there you can AirDrop them, copy them to iCloud Drive, or plug into a Mac.
Nothing is written to the system Photos library — deleting the app deletes the
clips, so move anything you want to keep.

Rough sizing at the default 1080p preset: a 10-second clip is around 20 MB, so a
two-hour painting session (60 clips) lands near 1.2 GB. The app warns you at
start if the phone has less than 500 MB free.

## Changing the timing

Both numbers live at the top of `HandsFreeRecorder/RecordingController.swift`:

```swift
static let clipDuration: TimeInterval = 10   // length of each clip
static let cycleInterval: TimeInterval = 120 // start-to-start gap
```

`cycleInterval` is measured start-of-clip to start-of-clip, so 10 / 120 means a
10-second clip followed by 110 seconds of idle. Clip times are computed off a
fixed anchor taken when you tap Start, so they don't drift over a long session.

## Known limits

- **Foreground only.** iOS suspends timers when an app leaves the screen, so the
  app stops the session and tells you if it gets backgrounded or the phone is
  locked. Turn on Guided Access (Settings → Accessibility → Guided Access) if
  you want to be sure a stray tap can't switch apps.
- **Back camera, portrait.** No front-camera or landscape option.
- A clip in progress when you hit STOP is still saved, just shorter than 10s.

## Layout

```
HandsFreeRecorder/
  HandsFreeRecorderApp.swift   App entry point
  ContentView.swift            Screen layout, status readout, START/STOP buttons
  CameraPreview.swift          AVCaptureVideoPreviewLayer wrapped for SwiftUI
  RecordingController.swift    Capture session + the repeating clip schedule
  ClipStorage.swift            Folder location, timestamped filenames, free space
```
