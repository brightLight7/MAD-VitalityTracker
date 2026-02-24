//
//  ToDoListController.swift
//  CI6330 Todo Swift UI
//
//  Created by Sajid, OJ on 03/02/2026.
//

import SwiftUI
import SwiftData
import Foundation



class HabitListController: ObservableObject{
    private var modelContext: ModelContext?
    @Published var habitItems: [Item] = []
    @Published var dailyLog: [String : DailyLog] = [:]
    @Published var selectedDate: Date = Date()
    private var calendar: Calendar {Calendar.current}
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        fetchItems()
    }
    
    func setModelContext(_ context: ModelContext)
    {
        modelContext = context
        fetchItems()
    }
    
    // (C)REATE
    func addItem(title: String, to category: Category)
    {
        guard let modelContext = modelContext else {return}
        guard !title.isEmpty else {return}
        let newItem = Item(title: title)
        modelContext.insert(newItem)
        category.items.append(newItem)
        saveContent()
        fetchItems()
    }
    
    // (C)REATE
//    func addItem(_ title: String)
//    {
//        guard let modelContext = modelContext else {return}
//        guard !title.isEmpty else {return}
//        let newItem = Item(title: title)
//        modelContext.insert(newItem)
//        saveContent()
//        fetchItems()
//    }
    
    // (R)EAD
    func fetchItems() {
        guard let modelContext = modelContext else {return}
        do {
            habitItems = try modelContext.fetch(FetchDescriptor<Item>())
        }
        catch
        {
            print("Failed to fetch items: \(error)")
        }
    }
    
    // (U)PDATE
    func toggleItem(_ item: Item)
    {
        item.isDone.toggle()
        saveContent()
    }
 
    // (D)ELETE
    func deleteItem(_ item: Item)
    {
        guard let modelContext = modelContext else {return}
        modelContext.delete(item)
        saveContent()
        fetchItems()
    }
    

    private func saveContent()
    {
        guard let modelContext = modelContext else {return}
        do
        {
            try modelContext.save()
        }
        catch
        {
            print("Failed to save content: \(error)")
        }
    }
    
    func filteredTodoItems(searchQuery: String) -> [Item]
    {
        if searchQuery.isEmpty {
            return habitItems
            
        }
        else
        {
            return habitItems.filter { $0.title.localizedCaseInsensitiveContains(searchQuery)}
        }
    }
    
    func filteredCatItems(for category: Category?, searchQuery: String) -> [Item]
    {
        if let category = category
        {
            if searchQuery.isEmpty
            {
                return category.items
            }
            else
            {
                return category.items.filter {$0.title.localizedCaseInsensitiveContains(searchQuery)}
            }
        }
        else
        {
            return habitItems
        }
    }
    
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
    
    // Insertion or Removal of UUID
    func toggleCompletionToday(_ item: Item)
    {
        let key = dayKey(for: Date())
        var log = dailyLog[key] ?? DailyLog(date: calendar.startOfDay(for: Date()), IDs_completedHabit: [])
        if log.IDs_completedHabit.contains(item.id)
        {
            log.IDs_completedHabit.remove(item.id)
        }
        else
        {
            log.IDs_completedHabit.insert(item.id)
        }
        
        dailyLog[key] = log
    }
    
    func streak (for item: Item) -> Int{
        var streakCount = 0
        var day = calendar.startOfDay(for: Date())
        
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
