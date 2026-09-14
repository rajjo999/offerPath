import SwiftUI

struct TabViewContainer: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeDashboardView()
                .tag(0)
                .tabItem {
                    Label("Home", systemIcon: "house.fill")
                }
            
            PipelineView()
                .tag(1)
                .tabItem {
                    Label("Pipeline", systemIcon: "square.stack.3d.up.fill")
                }
            
            Text("Calendar")
                .tag(2)
                .tabItem {
                    Label("Calendar", systemIcon: "calendar")
                }
            
            Text("Practice")
                .tag(3)
                .tabItem {
                    Label("Practice", systemIcon: "doc.text.magnifyingglass")
                }
            
            Text("Settings")
                .tag(4)
                .tabItem {
                    Label("Settings", systemIcon: "gearshape.fill")
                }
        }
        .accentColor(ColorTokens.primaryGreen)
    }
}
