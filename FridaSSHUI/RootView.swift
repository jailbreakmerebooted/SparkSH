import SwiftUI

struct Root: View {
    @State private var selectedTab = 0
    @AppStorage("ip") var ip = "127.1"
    @AppStorage("port") private var port = "2222"
    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView(ip: $ip, port: $port)
                .tabItem {
                    Text("Home")
                }
                .tag(0)

            Text("Tab 2 Content")
                .tabItem {
                    Text("Shortcuts")
                }
                .tag(1)

            Settings(ip: $ip, port: $port)
                .tabItem {
                    Text("Settings")
                }
                .tag(2)
        }
        .padding()
    }
}
