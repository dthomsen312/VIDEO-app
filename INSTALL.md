# Getting VIDEO onto your iPhone

Start to finish this is about 20 minutes of your attention, plus a long Xcode
download you can walk away from. Everything here is free — no developer account
needed.

You need a Mac running macOS 14.5 or later, an iPhone on iOS 17 or later, and a
cable to connect them.

---

## Step 1 — Install Xcode

Open the **App Store** on your Mac, search for **Xcode**, and install it. It's
about 10 GB, so start it and go do something else.

When it finishes, open Xcode once and accept the license agreement it shows.

## Step 2 — Get the code onto the Mac

1. In a browser, go to your repository: `github.com/dthomsen312/VIDEO-app`
2. Click the **branch** dropdown (it probably says `main`) and pick
   **`claude/iphone-hands-free-recorder-pwgepp`**. This matters — the app isn't
   on `main`.
3. Click the green **Code** button → **Download ZIP**.
4. Find the ZIP in your Downloads and double-click to unzip it.

## Step 3 — Open the project

Inside the unzipped folder, double-click **`HandsFreeRecorder.xcodeproj`**. It
has a blue blueprint-style icon. Xcode opens.

Give it a minute on first open — it indexes the project and the window may look
busy or unresponsive while it does.

## Step 4 — Add your Apple ID to Xcode

1. Menu bar: **Xcode → Settings** (or press `⌘,`)
2. Click the **Accounts** tab
3. Click **+** in the bottom-left → **Apple ID** → sign in with your normal
   Apple ID (same one as your iPhone)
4. Close the Settings window

This is what lets Xcode sign the app for your own device. You're not enrolling
in anything or paying for anything.

## Step 5 — Set the signing team

1. In the left sidebar, click the **blue project icon** at the very top (named
   `HandsFreeRecorder`)
2. In the main panel, under **TARGETS**, select **VIDEO**
3. Click the **Signing & Capabilities** tab
4. Make sure **Automatically manage signing** is checked
5. Set **Team** to your name — it'll appear as *"Your Name (Personal Team)"*

## Step 6 — Give the app a unique ID

Still on the **Signing & Capabilities** tab, find **Bundle Identifier**. It
currently reads `com.example.HandsFreeRecorder`.

Change it to something nobody else would use, like:

```
com.dthomsen.video
```

Apple requires these to be globally unique. If you skip this step you'll likely
get a *"failed to register bundle identifier"* error.

## Step 7 — Connect your iPhone

1. Plug the iPhone into the Mac with a cable (a charge-only cable won't work —
   it needs to carry data)
2. Unlock the phone
3. If it asks **"Trust This Computer?"** tap **Trust** and enter your passcode

## Step 8 — Pick your phone as the destination

At the top of the Xcode window there's a dropdown showing something like
*"VIDEO > iPhone 15 Simulator"*. Click it and choose **your actual iPhone** from
the list, under the "Device" heading.

This matters: the app will build fine in a Simulator but the camera doesn't work
there, so you must run it on the real phone.

## Step 9 — Build and run

Press **⌘R**, or click the **▶︎ play button** in the toolbar.

Xcode compiles the app and installs it. First time takes a couple of minutes.
Watch the status area at the top for progress.

## Step 10 — Trust the app on your phone

The first install will fail to launch with a message about an untrusted
developer. That's expected. On the **iPhone**:

**Settings → General → VPN & Device Management → [your Apple ID] → Trust**

Then press **⌘R** in Xcode again, or just tap the VIDEO icon on your home
screen.

## Step 11 — First launch

The app asks for **camera**, **microphone**, and **Add to Photos** access.
Allow all three. Declining Photos means clips stay inside the app instead of
going to your CLIPS album.

You should now have a **VIDEO** icon on your home screen with a red record dot.

---

## The 7-day thing

Apps signed with a free Apple ID stop working after **7 days**. To refresh:
plug the phone in, open the project, press ⌘R. Takes under a minute.

A [paid Apple Developer account](https://developer.apple.com/programs/) ($99 a
year) extends this to a year at a time. Worth it only if you end up using the
app regularly.

---

## When something goes wrong

**"Signing for VIDEO requires a development team"**
Step 5 didn't take. Go back to Signing & Capabilities and pick your Team.

**"Failed to register bundle identifier"**
The identifier is already taken. Step 6 — make it more unique, add some digits.

**"Untrusted Developer" when launching**
Step 10. This is normal on the first install.

**Your iPhone doesn't appear in the destination dropdown**
Unlock the phone and check you tapped Trust. Try a different cable — many are
charge-only. If it still won't show, in Xcode go to **Window → Devices and
Simulators** and see whether the phone is listed there.

**"The project is damaged and cannot be opened" or a version complaint**
Your Xcode is too old. This project needs Xcode 16 or newer. Update via the App
Store. If your Mac can't run Xcode 16, tell me and I'll convert the project to
the older format.

**"Unsupported OS version" or deployment target errors**
The app needs iOS 17 or later. Check **Settings → General → About** on the
phone.

**Build errors in the Swift code**
Copy the exact red error text and send it over — that's a code problem, not
something you did wrong.
