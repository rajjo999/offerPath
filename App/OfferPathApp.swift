import SwiftUI
import SwiftData

@main
struct OfferPathApp: App {
    let container: ModelContainer
    
    init() {
        do {
            let schema = Schema([
                JobApplication.self,
                StoredCalendarEvent.self
            ])
            let configuration = ModelConfiguration(schema: schema)
            container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            TabViewContainer()
                .modelContainer(container)
                .preferredColorScheme(.dark)
        }
    }
}
