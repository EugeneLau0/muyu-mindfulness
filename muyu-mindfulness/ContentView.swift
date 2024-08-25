//
//  ContentView.swift
//  muyu-mindfulness
//
//  Created by yuanjun on 2024/8/25.
//

import SwiftUI
import UIKit
import AVFoundation

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ContentView: View {
    // 使用@State来创建一个状态变量，用于存储计数器的值
    @State private var counter = 0
    // AVAudioPlayer用于播放声音
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        VStack {
            // 显示计数器的标签
            Text("计数: \(counter)").font(.largeTitle)
            
            // 创建一个按钮，点击时调用incrementCounter函数
            Button(action: {
                // 每次点击，计数器增加1
                self.incrementCounter()
                // 播放声音
                self.playSound()
            }) {
                Text("敲我敲我").fontWeight(.bold).font(.title)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
        }.onAppear() {
            // 当视图出现时，准备要播放的声音
            self.prepareSound()
        }.onDisappear {
            audioPlayer?.stop()
            audioPlayer = nil
        }
    }
    
    // 定义一个函数，用于增加计数器的值
    private func incrementCounter() {
        counter += 1
    }
    
    private func playSound() {
        audioPlayer?.play()
    }
    
    private func prepareSound() {
        let sourceName = "sound_2"
        let extensionName = "mp3"
        guard let soundURL = Bundle.main.url(forResource: sourceName, withExtension: extensionName) else {
            print("音频资源 \(sourceName).\(extensionName)未找到！")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("无法创建音频播放器: \(error.localizedDescription)")
        }
    }
}
