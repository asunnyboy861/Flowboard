import SwiftUI
import CoreData

@main
struct FlowboardApp: App {
    let persistenceController = PersistenceController.shared

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    MainTabView()
                } else {
                    OnboardingView()
                }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .task {
                _ = await NotificationService.shared.requestAuthorization()
            }
        }
    }
}
