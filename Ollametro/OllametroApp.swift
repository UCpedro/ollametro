import SwiftUI

@main
struct OllametroApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: OllametroViewModel())
        }
    }
}
