import SwiftUI

struct SettingsView: View {
    @ObservedObject var userDefaultsManager: UserDefaultsManager
    @State private var tempDailyGoal: String = ""

    var body: some View {
        Form {
            Section(header: Text("音量设置")) {
                Slider(value: $userDefaultsManager.soundVolume, in: 0...1, step: 0.1)
                Text("当前音量: \(Int(userDefaultsManager.soundVolume * 100))%")
            }

            Section(header: Text("每日目标")) {
                HStack {
                    Text("每日目标:")
                    TextField("输入目标", text: $tempDailyGoal)
                        .keyboardType(.numberPad)
                        .onAppear {
                            tempDailyGoal = "\(userDefaultsManager.dailyGoal)"
                        }
                }
                Button("保存目标") {
                    if let newGoal = Int(tempDailyGoal), newGoal > 0 {
                        userDefaultsManager.dailyGoal = newGoal
                    } else {
                        tempDailyGoal = "\(userDefaultsManager.dailyGoal)"
                    }
                }
            }
        }
    }
}
