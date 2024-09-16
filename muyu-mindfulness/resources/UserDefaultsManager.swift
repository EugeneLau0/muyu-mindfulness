import Foundation

class UserDefaultsManager: ObservableObject {
    @Published var totalCount: Int = UserDefaults.standard.integer(forKey: "totalCount") {
        didSet {
            UserDefaults.standard.set(totalCount, forKey: "totalCount")
        }
    }
    @Published var todayCount: Int = UserDefaults.standard.integer(forKey: "todayCount") {
        didSet {
            UserDefaults.standard.set(todayCount, forKey: "todayCount")
        }
    }
    @Published var dailyGoal: Int = UserDefaults.standard.integer(forKey: "dailyGoal") {
        didSet {
            UserDefaults.standard.set(dailyGoal, forKey: "dailyGoal")
        }
    }
    @Published var lastSavedDate: Date = UserDefaults.standard.object(forKey: "lastSavedDate") as? Date ?? Date() {
        didSet {
            UserDefaults.standard.set(lastSavedDate, forKey: "lastSavedDate")
        }
    }
    @Published var soundVolume: Double {
        didSet {
            UserDefaults.standard.set(soundVolume, forKey: "soundVolume")
        }
    }

    init() {
        self.soundVolume = UserDefaults.standard.double(forKey: "soundVolume")
        if self.soundVolume == 0 {
            self.soundVolume = 1.0 // 默认音量为最大
        }
    }

    func incrementCounter() {
        todayCount += 1
        totalCount += 1
    }

    func checkAndResetDailyCount() {
        let calendar = Calendar.current
        if !calendar.isDate(lastSavedDate, inSameDayAs: Date()) {
            todayCount = 0
            lastSavedDate = Date()
        }
        if dailyGoal < 1 {
            dailyGoal = 1
        }
    }
}
