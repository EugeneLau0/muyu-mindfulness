//
//  ContentView.swift
//  muyu-mindfulness
//
//  Created by yuanjun on 2024/8/25.
//

import SwiftUI
import UIKit

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}

struct ContentView: View {
    // 使用@State来创建一个状态变量，用于存储计数器的值
    @State private var counter = 0

    var body: some View {
        VStack {
            // 显示计数器的标签
            Text("计数: \(counter)")
                .font(.largeTitle)
            
            // 创建一个按钮，点击时调用incrementCounter函数
            Button(action: {
                // 每次点击，计数器增加1
                self.incrementCounter()
            }) {
                Text("敲我敲我")
                    .fontWeight(.bold)
                    .font(.title)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
        }
    }
    
    // 定义一个函数，用于增加计数器的值
    private func incrementCounter() {
        counter += 1
    }
}
