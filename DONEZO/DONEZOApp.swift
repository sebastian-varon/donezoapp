import SwiftUI

@main
struct DONEZOApp: App {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = true
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
