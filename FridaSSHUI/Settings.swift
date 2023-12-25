import SwiftUI

struct Settings: View {
    @Binding var ip: String
    @Binding var port: String
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: connection(ip: $ip, port: $port)) {
                    Text("connection")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct connection: View {
    @Binding var ip: String
    @Binding var port: String
    var body: some View {
        TextField("ip address", text: $ip)
        TextField("port number", text: $port)
    }
}
