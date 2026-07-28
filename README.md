# VIDEO — hands-free interval recorder for iPhone

A single-purpose iPhone app for filming yourself while you work. Tap **START**,
prop the phone up, and it records a **10-second clip every 2 minutes** until you
tap **STOP**. Between clips the camera sits idle with a live preview, so nothing
is being written and the battery isn't burning through a full-length recording.

You touch the phone twice per session: once to start, once to stop.

## Installing it

**→ [INSTALL.md](INSTALL.md) has click-by-click instructions**, including the
Xcode setup and what to do when the usual errors come up.

The short version, if you already know Xcode: open
`HandsFreeRecorder.xcodeproj`, set a signing Team and a unique bundle
identifier on the **VIDEO** target, pick your iPhone as the destination, ⌘R.
Needs Xcode 16+, an iPhone on iOS 17+, and a real device — the camera doesn't
work in the Simulator.

It installs like any other app: a **VIDEO** icon on your home screen that you
tap to launch. The Mac is only needed to put it there and to refresh the
signing every 7 days on a free Apple ID (a paid developer account extends that
to a year).

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

Each clip lands in your **Photos library**, in an album called **CLIPS**. They
show up in the camera roll like anything else you shoot, back up with iCloud
Photos, and survive deleting the app. The album is created automatically the
first time a clip is saved — you don't need to make it yourself.

Under the hood a clip is first written to `Documents/Recordings` with a
timestamped name, then copied into Photos:

```
Clip_2026-07-28_14-32-05.mov
Clip_2026-07-28_14-34-05.mov
```

The working file is deleted only after Photos confirms it has the clip, so a
failed save leaves the file in place rather than losing it. If a save does fail,
the app says so and the clip stays in **Files → On My iPhone → VIDEO →
Recordings**. That's also where everything goes if you decline Photos access —
the app keeps recording either way.

The footer on screen shows both tallies (`12 clips · 12 in Photos`), so a
drifting gap between the two numbers means saves are failing.

Rough sizing at the default 1080p preset: a 10-second clip is around 20 MB, so a
two-hour painting session (60 clips) lands near 1.2 GB. The app warns you at
start if the phone has less than 500 MB free.

## Instagram Reels format (web version)

Clips come out **1080×1920, 9:16, 30 fps, H.264 High profile with AAC audio**,
at roughly 10 Mbps — ready to post with no cropping or re-encoding.

1080×1920 is deliberately the ceiling, not a compromise. Instagram re-encodes
every upload down to 1080 wide, so 4K source gains nothing and costs battery,
heat, and storage to capture. 10 Mbps is comfortably above what Instagram
retains, so their pass is effectively transparent.

If the camera ever refuses to deliver portrait 9:16, frames are routed through
a 1080×1920 centre-crop canvas so the file is Reels-shaped regardless. On an
iPhone in portrait this path stays dormant and costs nothing. The tally line
shows the resolution actually being captured.

## Battery

The camera is **powered down between clips**. It wakes 3 seconds before each
clip so auto-exposure and white balance settle, records its 10 seconds, then
shuts off — about 13 seconds of sensor time per 2-minute cycle instead of 120.
Over a two-hour session that is roughly a tenth of the camera duty cycle.

Three smaller savings on top:

- The countdown loop wakes once a second while idling and only tightens near a
  clip boundary, instead of five times a second throughout.
- The idle screen is pure black, which on an OLED panel means unlit pixels.
- Capture is capped at 30 fps, and the canvas path (when used at all) is
  throttled to 30 fps rather than tracking the 120 Hz display.

`track.stop()` is what actually powers the sensor down — setting
`track.enabled = false` only blanks the frames and leaves the camera running.

The screen still has to stay on for the whole session, and that remains the
largest single draw. Keep the phone plugged in for anything long.

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
  PhotoLibrarySaver.swift      Copies finished clips into the Photos CLIPS album
  Assets.xcassets/             App icon and accent color
```
