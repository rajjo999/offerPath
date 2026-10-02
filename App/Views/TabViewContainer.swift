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

            WeeklyDashboardView()
                .tag(2)
                .tabItem {
                    Label(
                        "Practice",
                        systemImage: "doc.text.magnifyingglass"
                    )
                }
        }
        .tint(ColorTokens.primaryGreen)
    }
}
