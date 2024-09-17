import SwiftUI

struct SettingsView: View {
    @ObservedObject var audioManager: AudioManager
    @ObservedObject var userDefaultsManager: UserDefaultsManager
    @State private var tempDailyGoal: String = ""
    @State private var isCustomGoal: Bool = false
    @State private var showingResetAlert = false
    @State private var showingStatistics = false
    @State private var tempAutoExecuteInterval: String = ""
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
                            ForEach(presetGoals.indices, id: \.self) { index in
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

                Section(header: Text("统计")) {
                    Button("查看功德统计") {
                        showingStatistics = true
                    }
                }
                
                Section(header: Text("自动功德设置")) {
                    Toggle("启用自动功德", isOn: $userDefaultsManager.isAutoExecuteEnabled)
                    
                    if userDefaultsManager.isAutoExecuteEnabled {
                        HStack {
                            Text("时间间隔（秒）")
                            TextField("输入时间间隔", text: $tempAutoExecuteInterval)
                                .keyboardType(.decimalPad)
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
            .sheet(isPresented: $showingStatistics) {
                StatisticsView(userDefaultsManager: userDefaultsManager)
            }
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
            tempAutoExecuteInterval = String(format: "%.1f", userDefaultsManager.autoExecuteInterval)
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

        if let newInterval = Double(tempAutoExecuteInterval), newInterval > 0 {
            userDefaultsManager.autoExecuteInterval = newInterval
        }
    }

    private func resetAllSettings() {
        userDefaultsManager.resetAllData()
        audioManager.resetToDefaults()
        isCustomGoal = false
        tempDailyGoal = "100" // 假设100是默认的每日目标
        presentationMode.wrappedValue.dismiss()
    }
}
