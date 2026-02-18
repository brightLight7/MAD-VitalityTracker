//
//  ToDoListController.swift
//  CI6330 Todo Swift UI
//
//  Created by Sajid, OJ on 03/02/2026.
//

import SwiftUI
import SwiftData



class HabitController: ObservableObject{
    private var modelContext: ModelContext?
    @Published var habitItems: [Item] = []
    @Published var dailyLog: [String : DailyLog]
    @State var streak = 0
    
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
    
    func streaks(_ item: Item)
    {
        var day = Date.now
        var yesterday = 
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dayKey = formatter.string(from: day)
        
        
        while let log = dailyLog[dayKey]
        {
            if log.IDs_completedHabit.contains(item.id)
            {
                streak = streak + 1
                day = Date.
            }
            
        }
    }
}
