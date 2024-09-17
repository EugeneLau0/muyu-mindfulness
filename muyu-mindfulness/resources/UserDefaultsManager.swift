import Foundation

class UserDefaultsManager: ObservableObject {
    @Published var totalCount: Int {
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
    @Published var soundVolume: Double
    @Published var isAutoExecuteEnabled: Bool
    @Published var autoExecuteInterval: Double

    init() {
        self.soundVolume = UserDefaults.standard.double(forKey: "soundVolume")
        self.isAutoExecuteEnabled = UserDefaults.standard.bool(forKey: "isAutoExecuteEnabled")
        self.autoExecuteInterval = UserDefaults.standard.double(forKey: "autoExecuteInterval")
        self.totalCount = UserDefaults.standard.integer(forKey: "totalCount")
        
        if self.soundVolume == 0 {
            self.soundVolume = 1.0 // 默认音量为最大
        }
        if self.autoExecuteInterval == 0 {
            self.autoExecuteInterval = 1.0 // 默认为1秒
        }
        if self.dailyGoal == 0 {
            self.dailyGoal = 100 // 默认目标
        }
        
        checkAndResetDailyCount()
        recalculateTotalCount()
    }

    private let dailyCountsKey = "dailyCounts"

    func saveDailyCount() {
        let today = Calendar.current.startOfDay(for: Date())
        var dailyCounts = UserDefaults.standard.dictionary(forKey: dailyCountsKey) as? [String: Int] ?? [:]
        dailyCounts[dateFormatter.string(from: today)] = todayCount
        UserDefaults.standard.set(dailyCounts, forKey: dailyCountsKey)
    }

    func getDailyCounts() -> [(date: Date, count: Int)] {
        let dailyCounts = UserDefaults.standard.dictionary(forKey: dailyCountsKey) as? [String: Int] ?? [:]
        return dailyCounts.compactMap { (dateString, count) in
            guard let date = dateFormatter.date(from: dateString) else { return nil }
            return (date, count)
        }.sorted { $0.date > $1.date }
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    func incrementCounter() {
        checkAndResetDailyCount() // 每次增加计数时检查是否需要重置
        totalCount += 1
        todayCount += 1
        saveDailyCount()
        objectWillChange.send()
    }

    func checkAndResetDailyCount() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let savedDate = calendar.startOfDay(for: lastSavedDate)
        
        if today != savedDate {
            saveDailyCount() // 保存昨天的计数
            todayCount = 0
            lastSavedDate = today
        }
    }

    func recalculateTotalCount() {
        let dailyCounts = getDailyCounts()
        totalCount = dailyCounts.reduce(0) { $0 + $1.count }
    }

    func resetAllData() {
        totalCount = 0
        todayCount = 0
        dailyGoal = 100 // 默认目标
        lastSavedDate = Date()
        
        UserDefaults.standard.removeObject(forKey: "totalCount")
        UserDefaults.standard.removeObject(forKey: "todayCount")
        UserDefaults.standard.removeObject(forKey: "dailyGoal")
        UserDefaults.standard.removeObject(forKey: "lastSavedDate")
        UserDefaults.standard.removeObject(forKey: dailyCountsKey)
    }
}
