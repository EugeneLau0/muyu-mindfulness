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

    var body: some View {
        NavigationView {
            WoodenFishView(audioManager: audioManager, userDefaultsManager: userDefaultsManager)
                .navigationBarItems(trailing: Button(action: {
                    showSettings = true
                }) {
                    Image(systemName: "gearshape")
                        .foregroundColor(.white)
                })
                .navigationBarTitle("", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showSettings) {
            SettingsView(audioManager: audioManager, userDefaultsManager: userDefaultsManager)
        }
        .onAppear {
            
            userDefaultsManager.checkAndResetDailyCount()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(audioManager: AudioManager(), userDefaultsManager: UserDefaultsManager())
    }
}
