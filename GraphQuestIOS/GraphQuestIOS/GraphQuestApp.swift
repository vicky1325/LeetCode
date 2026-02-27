import SwiftUI

@main
struct GraphQuestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: GameViewModel())
        }
    }
}
