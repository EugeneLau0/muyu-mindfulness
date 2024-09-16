import SwiftUI

struct SettingsView: View {
    @ObservedObject var audioManager: AudioManager
    @ObservedObject var userDefaultsManager: UserDefaultsManager
    @State private var tempDailyGoal: String = ""
    @State private var isCustomGoal: Bool = false
    @State private var showingResetAlert = false
    @Environment(\.presentationMode) var presentationMode

    let presetGoals = [100, 500, 1000]

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
                    Picker("选择目标", selection: $isCustomGoal) {
                        Text("预设目标").tag(false)
                        Text("自定义目标").tag(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    if !isCustomGoal {
                        Picker("预设目标", selection: Binding(
                            get: { self.presetGoals.firstIndex(of: self.userDefaultsManager.dailyGoal) ?? 0 },
                            set: { self.userDefaultsManager.dailyGoal = self.presetGoals[$0] }
                        )) {
                            ForEach(0..<presetGoals.count) { index in
                                Text("\(self.presetGoals[index])").tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    } else {
                        HStack {
                            Text("自定义目标:")
                            TextField("输入目标", text: $tempDailyGoal)
                                .keyboardType(.numberPad)
                        }
                    }
                }

                Section(header: Text("重置")) {
                    Button("重置所有设置和数据") {
                        showingResetAlert = true
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationBarTitle("设置", displayMode: .inline)
            .navigationBarItems(trailing: Button("完成") {
                saveSettings()
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showingResetAlert) {
                Alert(
                    title: Text("确认重置"),
                    message: Text("这将重置所有设置和数据到初始状态。此操作不可撤销。"),
                    primaryButton: .destructive(Text("重置")) {
                        resetAllSettings()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .onAppear {
            isCustomGoal = !presetGoals.contains(userDefaultsManager.dailyGoal)
            tempDailyGoal = "\(userDefaultsManager.dailyGoal)"
        }
        .onDisappear {
            saveSettings()
        }
    }

    private func saveSettings() {
        if isCustomGoal {
            if let newGoal = Int(tempDailyGoal), newGoal > 0 {
                userDefaultsManager.dailyGoal = newGoal
            }
        }
        // 预设目标和音量设置已经通过 Picker 和 Slider 的绑定自动保存了
    }

    private func resetAllSettings() {
        userDefaultsManager.resetAllData()
        audioManager.resetToDefaults()
        isCustomGoal = false
        tempDailyGoal = "100" // 假设100是默认的每日目标
        presentationMode.wrappedValue.dismiss()
    }
}
