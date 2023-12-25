//
//  main.swift
//  FridaSSH
//
//  Created by Seam Boleslawski on 17.12.23.
//

import Foundation

func runCommand(command: String) {
    let process = Process()
    process.launchPath = "/bin/zsh" // or "/bin/bash" or the path to your preferred shell
    process.arguments = ["-c", command]

    let pipe = Pipe()
    process.standardOutput = pipe
    process.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    if let output = String(data: data, encoding: .utf8) {
        print("Command output: \(output)")
    }

    process.waitUntilExit()
}
