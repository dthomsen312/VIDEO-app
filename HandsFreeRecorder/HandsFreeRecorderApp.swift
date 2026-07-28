import SwiftUI

@main
struct HandsFreeRecorderApp: App {
    @StateObject private var controller = RecordingController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(controller)
                .preferredColorScheme(.dark)
                .statusBarHidden(true)
        }
    }
}
