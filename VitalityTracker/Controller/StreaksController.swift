import SwiftUI
import SwiftData
import Foundation

class StreaksController: ObservableObject
{
    private var modelContext: ModelContext?
    @Published var habitItems: [Item] = []
    @Published var dailyLog: [String : DailyLog] = [:]
    @Published var selectedDate: Date = Date()
    private var calendar: Calendar {Calendar.current}
    // Part of the Streaks component:
    // Reusable Formatter component
    private static let dayKeyFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd" // MM means months whereas mm would means minutes...
        return df
    }()
    
    private func dayKey(for date : Date) -> String {
        let day = calendar.startOfDay(for: date)
        return Self.dayKeyFormatter.string(from: day)
    }
    
    func isCompleted(_ itemID: UUID, on date: Date) -> Bool
    {
        let key = dayKey(for: date)
        return dailyLog[key]?.IDs_completedHabit.contains(itemID) == true
    }
    
    private func previousDay(_ date : Date) -> Date {
        calendar.date(byAdding: .day, value: -1, to: date) ?? date
    }
    
    private func getOrCreateALog(for date : Date) -> DailyLog {
        let day = calendar.startOfDay(for: date)
        let key = dayKey(for: day)
        
        if let existing = dailyLog[key] {
            return existing
        }
        
        let created = DailyLog(date: day, IDs_completedHabit: [])
        dailyLog[key] = created
        return created
    }
    
    // Checker of Habit completion
    func isHabitCompletedToday(_ item: Item) -> Bool {
        let key = dayKey(for: Date())
        return dailyLog[key]?.IDs_completedHabit.contains(item.id) ?? false
    }
    
    func toggleCompletion(_ itemID: UUID, on date: Date)
    {
        let k = dayKey(for: date)
        var log = dailyLog[k] ?? DailyLog(date: calendar.startOfDay(for: date), IDs_completedHabit: [])
        
        if dailyLog[k] == nil
        {
            dailyLog[k] = DailyLog(date: calendar.startOfDay(for: date),
            IDs_completedHabit: [])
        }
        
        if log.IDs_completedHabit.contains(itemID)
        {
            log.IDs_completedHabit.remove(itemID)
        }
        else
        {
            log.IDs_completedHabit.insert(itemID)
        }
        dailyLog[k] = log
        //print("dailyLog keys:", dailyLog.keys.sorted())
    }
    // Insertion or Removal of UUID
    func toggleCompletionToday(_ itemID: UUID)
    {

        toggleCompletion(itemID, on: Date())
        print("dailyLog keys:", dailyLog.keys.sorted())
    }
    
    func streak (for item: Item) -> Int
    {
        streak(for: item, endingOn: Date())
    }
    
    
    func streak (for item: Item, endingOn endDate: Date) -> Int{
        var streakCount = 0
        var day = calendar.startOfDay(for: endDate)
        
        while true
        {
            let key = dayKey(for: day)
            guard let log = dailyLog[key],
                  log.IDs_completedHabit.contains(item.id)
            else
            {
                break
            }
            
            streakCount += 1
            let previousDay = previousDay(day)
            
            //Simple error handling if previous day fails
            if previousDay == day {break}
            
            day = previousDay
        }
        return streakCount
    }
}
