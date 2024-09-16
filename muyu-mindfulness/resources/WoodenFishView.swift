import SwiftUI

struct WoodenFishView: View {
    @ObservedObject var audioManager: AudioManager
    @ObservedObject var userDefaultsManager: UserDefaultsManager
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // 背景
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // 标题
                Text("木鱼禅修")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                
                // 木鱼图像
                Image(systemName: "seal.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.orange) // 你可以选择任何适合的颜色
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0.3), value: isAnimating)
                
                // 计数器
                Text("\(userDefaultsManager.todayCount)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                
                // 功德+1 按钮
                Button(action: {
                    userDefaultsManager.incrementCounter()
                    audioManager.playSound()
                    isAnimating = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isAnimating = false
                    }
                }) {
                    Text("功德+1")
                        .fontWeight(.bold)
                        .font(.title2)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                }
                
                // 统计信息
                VStack(spacing: 10) {
                    Text("今日功德: \(userDefaultsManager.todayCount)")
                    Text("总功德: \(userDefaultsManager.totalCount)")
                    Text("每日目标: \(userDefaultsManager.todayCount)/\(userDefaultsManager.dailyGoal)")
                }
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.white)
                
                // 进度条
                ProgressView(value: min(Double(userDefaultsManager.todayCount), Double(userDefaultsManager.dailyGoal)), total: Double(max(1, userDefaultsManager.dailyGoal)))
                    .progressViewStyle(LinearProgressViewStyle(tint: .white))
                    .frame(width: 250)
            }
            .padding()
        }
    }
}
