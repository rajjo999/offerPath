import SwiftUI
import SwiftData

struct TabViewContainer: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeDashboardView()
                .tag(0)
                .tabItem {
                    Label(
                        "Home",
                        systemImage: "house.fill"
                    )
                }

            PipelineView()
                .tag(1)
                .tabItem {
                    Label(
                        "Pipeline",
                        systemImage: "square.stack.3d.up.fill"
                    )
                }

            Text("Calendar")
                .foregroundStyle(ColorTokens.primaryGreen)
                .tag(2)
                .tabItem {
                    Label(
                        "Calendar",
                        systemImage: "calendar"
                    )
                }

            Text("Practice")
                .foregroundStyle(ColorTokens.primaryGreen)
                .tag(3)
                .tabItem {
                    Label(
                        "Practice",
                        systemImage: "doc.text.magnifyingglass"
                    )
                }

            Text("Settings")
                .foregroundStyle(ColorTokens.primaryGreen)
                .tag(4)
                .tabItem {
                    Label(
                        "Settings",
                        systemImage: "gearshape.fill"
                    )
                }
        }
        .tint(ColorTokens.primaryGreen)
    }
}
