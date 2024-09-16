//
//  ContentView.swift
//  muyu-mindfulness
//
//  Created by yuanjun on 2024/8/25.
//

import SwiftUI
import UIKit
import AVFoundation

struct ContentView: View {
    @ObservedObject var audioManager: AudioManager
    @ObservedObject var userDefaultsManager: UserDefaultsManager
    @State private var showSettings = false

    init(audioManager: AudioManager, userDefaultsManager: UserDefaultsManager) {
        self.audioManager = audioManager
        self.userDefaultsManager = userDefaultsManager
    }

    var body: some View {
        NavigationView {
            WoodenFishView(audioManager: audioManager, userDefaultsManager: userDefaultsManager)
                .navigationBarItems(trailing: Button("设置") {
                    showSettings.toggle()
                })
                .sheet(isPresented: $showSettings) {
                    SettingsView(userDefaultsManager: userDefaultsManager)
                }
        }
        .onAppear {
            audioManager.prepareSound()
            userDefaultsManager.checkAndResetDailyCount()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(audioManager: AudioManager(), userDefaultsManager: UserDefaultsManager())
    }
}
