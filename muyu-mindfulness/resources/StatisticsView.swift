//
//  StatisticsView.swift
//  muyu-mindfulness
//
//  Created by yuanjun on 2024/9/16.
//

import Foundation
import SwiftUI

enum TimeRange: String, CaseIterable {
    case day = "天"
    case week = "周"
    case month = "月"
    case year = "年"
}

struct StatisticsView: View {
    @ObservedObject var userDefaultsManager: UserDefaultsManager
    @State private var selectedTimeRange: TimeRange = .day
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("时间范围", selection: $selectedTimeRange) {
                    ForEach(TimeRange.allCases, id: \.self) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    ForEach(getStatistics(), id: \.date) { stat in
                        HStack {
                            Text(formatDate(stat.date))
                            Spacer()
                            Text("\(stat.count)")
                        }
                    }
                }
            }
            .navigationBarTitle("功德统计", displayMode: .inline)
        }
    }
    
    func getStatistics() -> [(date: Date, count: Int)] {
        let allCounts = userDefaultsManager.getDailyCounts()
        switch selectedTimeRange {
        case .day:
            return allCounts
        case .week:
            // 按周合并数据
            return mergeByWeek(allCounts)
        case .month:
            // 按月合并数据
            return mergeByMonth(allCounts)
        case .year:
            // 按年合并数据
            return mergeByYear(allCounts)
        }
    }
    
    func mergeByWeek(_ counts: [(date: Date, count: Int)]) -> [(date: Date, count: Int)] {
        var mergedCounts: [Date: Int] = [:]
        let calendar = Calendar.current
        
        for count in counts {
            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: count.date))!
            mergedCounts[weekStart, default: 0] += count.count
        }
        
        return mergedCounts.map { (date: $0.key, count: $0.value) }
            .sorted { $0.date < $1.date }
        
    }
    
    func mergeByMonth(_ counts: [(date: Date, count: Int)]) -> [(date: Date, count: Int)] {
        // 实现按月合并的逻辑
        var mergedCounts: [Date: Int] = [:]
        let calendar = Calendar.current
        
        for count in counts {
            let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: count.date))!
            mergedCounts[monthStart, default: 0] += count.count
        }
        
        return mergedCounts.map { (date: $0.key, count: $0.value) }
            .sorted { $0.date < $1.date }
    }
    
    func mergeByYear(_ counts: [(date: Date, count: Int)]) -> [(date: Date, count: Int)] {
        // 实现按年合并的逻辑
        var mergedCounts: [Date: Int] = [:]
        let calendar = Calendar.current
        
        for count in counts {
            let yearStart = calendar.date(from: calendar.dateComponents([.year], from: count.date))!
            mergedCounts[yearStart, default: 0] += count.count
    }
    
    return mergedCounts.map { (date: $0.key, count: $0.value) }
        .sorted { $0.date < $1.date }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        switch selectedTimeRange {
        case .day:
            formatter.dateFormat = "yyyy-MM-dd"
        case .week:
            formatter.dateFormat = "yyyy'年第'w'周'"
        case .month:
            formatter.dateFormat = "yyyy-MM"
        case .year:
            formatter.dateFormat = "yyyy"
        }
        return formatter.string(from: date)
    }
}
