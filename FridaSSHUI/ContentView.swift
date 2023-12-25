import SwiftUI
import Foundation
import FluidGradient

struct ContentView: View {
    @State private var outputText = ""
    @Binding var ip: String
    @Binding var port: String
    var body: some View {
        ZStack {
            FluidGradient(blobs: [.green, .black],
                          highlights: [.green ,.black],
                          speed: 0.3,
                          blur: 0.75)
            .background(.quaternary)
            .ignoresSafeArea()
            VStack {
                Text("SparkSecureShell")
                    .font(.system(size: 20, weight: .bold))
                Rectangle()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.black)
                    .opacity(0.8)
                    .cornerRadius(25)
                    .overlay {
                        VStack {
                            Spacer().frame(height: 20)
                            Text("Guide")
                                .font(.system(size: 12, weight: .bold))
                            Spacer().frame(height: 20)
                            HStack {
                                Spacer().frame(width: 20)
                                Text("""
1. Use SDC on your phone to start sparkd
2. connect your phone to your mac using a usb cable
3. press on "connect to phone"
4. if a popup shows press yes
""")
                                .font(.system(size: 11, weight: .semibold))
                                Spacer().frame(width: 20)
                            }
                            Spacer()
                        }
                        .onAppear {
                            executeCommand(getBundlePath() + "/Contents/Resources/iproxy", arguments: [port,port])
                            executeCommand("/usr/bin/killall", arguments: ["Terminal"])
                        }
                    }
                Button("Connect") {
                    executeCommands()
                }
                Button("Disconnect") {
                    executeCommand("/usr/bin/killall", arguments: ["Terminal"])
                }
                Button("Exit") {
                    executeCommand("/usr/bin/killall", arguments: ["Terminal"])
                    executeCommand("/usr/bin/killall", arguments: ["iproxy"])
                    executeCommand("/usr/bin/killall", arguments: ["SparkSH"])
                }
                Spacer()
            }
            .padding()
        }
    }
    func setPathEnvironmentVariable(newPath: String) {
        // Convert Swift String to C String
        let newPathCString = (newPath as NSString).utf8String

        // Set the PATH environment variable
        if setenv("PATH", newPathCString, 1) != 0 {
            perror("setenv")
        }
    }
    func executeCommands() {
        executeCommandInNewTerminal(command: "bash " + getBundlePath() + "/Contents/Resources/lib/start.sh")
    }
    func executeCommand(command: String) {
        let process = Process()
        process.launchPath = "/usr/bin/env"
        process.arguments = [command]

        process.launch()
    }
    func executeCommandInNewTerminal(command: String) {
        let process = Process()
        process.launchPath = "/usr/bin/env"
        process.arguments = [
            "osascript",
            "-e", "tell application \"Terminal\"",
            "-e", "do script \"\(command)\" in front window",
            "-e", "activate",
            "-e", "end tell"
        ]

        process.launch()
    }
    func executeCommand(_ command: String, arguments: [String]) {
        print("Executing command: \(command) \(arguments.joined(separator: " "))")

        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.launchPath = command
        task.arguments = arguments

        task.launch()
    }
    func getBundlePath() -> String {
        return Bundle.main.bundlePath
    }
    func appendOutputText(_ text: String) {
        outputText += "\(text)\n"
    }
}
