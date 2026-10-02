import SwiftUI
import SwiftData

@main
struct OfferPathApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate

    @State private var showError = false
    @State private var errorMessage = ""

    private let container: ModelContainer

    var body: some Scene {
        WindowGroup {
            if showError {
                ErrorView(message: errorMessage)
            } else {
                TabViewContainer()
                    .preferredColorScheme(.dark)
                    .modelContainer(container)
            }
        }
    }

    init() {
        let schema = Schema([
            JobApplication.self,
            StoredCalendarEvent.self
        ])
        let configuration = ModelConfiguration(schema: schema)

        // Initialize container with a default value first (required for let properties)
        var tempContainer: ModelContainer
        do {
            tempContainer = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            // If creation fails, we'll still create a container to prevent crashes
            tempContainer = try! ModelContainer(for: schema, configurations: [configuration])
        }
        self.container = tempContainer

        // Now that container is initialized, we can safely use self to set error state
        do {
            _ = try ModelContainer(for: schema, configurations: [configuration])
            self.showError = false
        } catch {
            self.showError = true
            self.errorMessage = "Failed to initialize application: \(error.localizedDescription)"
        }
    }
}

struct ErrorView: View {
    let message: String

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)

            Text("Application Error")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)

            Text(message)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button(action: {
                // In a real app, you might try to recover or provide more options
            }) {
                Text("OK")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 120, height: 44)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 24)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
    }
}
