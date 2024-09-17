import SwiftUI

struct WoodenFishView: View {
    @ObservedObject var audioManager: AudioManager
    @ObservedObject var userDefaultsManager: UserDefaultsManager
    @State private var isAnimating = false
    @State private var timer: Timer?

    var body: some View {
        GeometryReader { outerGeometry in
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
                        .frame(width: 180, height: 180)
                        .foregroundColor(.orange)
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
                            .font(.system(size: 28))
                            .padding(.vertical, 20)
                            .padding(.horizontal, 40)
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .clipShape(Capsule())
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                    .scaleEffect(isAnimating ? 0.95 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0.3), value: isAnimating)
                    .keyboardShortcut(.space, modifiers: [])
                    
                    // 美化的数据区域
                    let statWidth = outerGeometry.size.width * 0.4
                    VStack(spacing: 20) {
                        HStack {
                            StatView(
                                title: "今日功德", 
                                value: "\(userDefaultsManager.todayCount)", 
                                titleFont: .system(.headline, design: .rounded),
                                valueFont: .system(size: 28, weight: .bold, design: .rounded),
                                width: statWidth
                            )
                            Spacer()
                            StatView(
                                title: "总功德", 
                                value: "\(userDefaultsManager.totalCount)",
                                titleFont: .system(.headline, design: .rounded),
                                valueFont: .system(size: 28, weight: .bold, design: .rounded),
                                width: statWidth
                            )
                        }
                        .frame(width: outerGeometry.size.width * 0.88)
                        
                        VStack(spacing: 10) {
                            Text("每日目标")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                            
                            Text("\(userDefaultsManager.todayCount)/\(userDefaultsManager.dailyGoal)")
                                .font(.system(.title, design: .rounded).bold())
                                .foregroundColor(.white)
                            
                            ProgressView(value: min(Double(userDefaultsManager.todayCount), Double(userDefaultsManager.dailyGoal)), total: Double(max(1, userDefaultsManager.dailyGoal)))
                                .progressViewStyle(LinearProgressViewStyle(tint: .white))
                        }
                        .frame(width: outerGeometry.size.width * 0.8)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                    }
                    .frame(width: outerGeometry.size.width * 0.86)
                    
                    Toggle("自动功德", isOn: $userDefaultsManager.isAutoExecuteEnabled)
                        .onChange(of: userDefaultsManager.isAutoExecuteEnabled) { newValue in
                            if newValue {
                                startAutoExecute()
                            } else {
                                stopAutoExecute()
                            }
                        }
                }
                .padding()
            }
        }
        .onAppear {
            if userDefaultsManager.isAutoExecuteEnabled {
                startAutoExecute()
            }
        }
        .onDisappear {
            stopAutoExecute()
        }
    }

    private func startAutoExecute() {
        timer = Timer.scheduledTimer(withTimeInterval: userDefaultsManager.autoExecuteInterval, repeats: true) { _ in
            userDefaultsManager.incrementCounter()
            audioManager.playSound()
            withAnimation {
                isAnimating = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isAnimating = false
                }
            }
        }
    }

    private func stopAutoExecute() {
        timer?.invalidate()
        timer = nil
    }
}

struct StatView: View {
    let title: String
    let value: String
    var titleFont: Font = .system(.headline, design: .rounded)
    var valueFont: Font = .system(size: 28, weight: .bold, design: .rounded)
    let width: CGFloat
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(titleFont)
                .foregroundColor(.white)
                .fontWeight(.semibold)
            Text(value)
                .font(valueFont)
                .foregroundColor(.white)
        }
        .frame(width: width, height: 100)
        .background(Color.white.opacity(0.2))
        .cornerRadius(15)
    }
}
