import SwiftUI

struct SettingsView: View {
    @ObservedObject var audioManager: AudioManager
    @ObservedObject var userDefaultsManager: UserDefaultsManager
    @State private var tempDailyGoal: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("音量设置")) {
                    Slider(value: Binding(
                        get: { Double(audioManager.volume) },
                        set: { audioManager.volume = Float($0) }
                    ), in: 0...1, step: 0.1)
                    Text("当前音量: \(Int(audioManager.volume * 100))%")
                }

                Section(header: Text("每日目标")) {
                    HStack {
                        Text("每日目标:")
                        TextField("输入目标", text: $tempDailyGoal)
                            .keyboardType(.numberPad)
                    }
                }
            }
            .navigationBarTitle("设置", displayMode: .inline)
            .navigationBarItems(trailing: Button("完成") {
                saveSettings()
                presentationMode.wrappedValue.dismiss()
            })
        }
        .onAppear {
            tempDailyGoal = "\(userDefaultsManager.dailyGoal)"
        }
        .onDisappear {
            saveSettings()
        }
    }

    private func saveSettings() {
        if let newGoal = Int(tempDailyGoal), newGoal > 0 {
            userDefaultsManager.dailyGoal = newGoal
        }
        // 音量设置已经通过 Slider 的绑定自动保存了
    }
}
