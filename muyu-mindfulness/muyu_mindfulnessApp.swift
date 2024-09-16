//
//  muyu_mindfulnessApp.swift
//  muyu-mindfulness
//
//  Created by yuanjun on 2024/8/25.
//

import SwiftUI

@main
struct muyu_mindfulnessApp: App {
    @StateObject private var audioManager = AudioManager()
    @StateObject private var userDefaultsManager = UserDefaultsManager()

    var body: some Scene {
        WindowGroup {
            ContentView(audioManager: audioManager, userDefaultsManager: userDefaultsManager)
        }
    }
}
