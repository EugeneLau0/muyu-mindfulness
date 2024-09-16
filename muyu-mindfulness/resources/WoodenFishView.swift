import SwiftUI

struct WoodenFishView: View {
    @ObservedObject var audioManager: AudioManager
    @ObservedObject var userDefaultsManager: UserDefaultsManager
    @State private var isAnimating = false

    var body: some View {
        VStack {
            Image("woodenFish") // 确保您的项目中有这个图片资源
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0.3), value: isAnimating)

            Text("\u{2665}  \(userDefaultsManager.todayCount)").font(.largeTitle)

            Button(action: {
                userDefaultsManager.incrementCounter()
                audioManager.playSound()
                isAnimating = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isAnimating = false
                }
            }) {
                Text("功德+1").fontWeight(.bold).font(.title)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)

            Text("今日功德: \(userDefaultsManager.todayCount)")
            Text("总功德: \(userDefaultsManager.totalCount)")
            ProgressView(value: min(Double(userDefaultsManager.todayCount), Double(userDefaultsManager.dailyGoal)), total: Double(max(1, userDefaultsManager.dailyGoal)))
            Text("每日目标: \(userDefaultsManager.todayCount)/\(userDefaultsManager.dailyGoal)")
        }
    }
}
