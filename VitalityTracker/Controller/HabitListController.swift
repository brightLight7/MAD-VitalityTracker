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
    func addItem(title: String, to category: Category, createdOn date: Date)
    {
        guard let modelContext = modelContext else {return}
        guard !title.isEmpty else {return}
        let newItem = Item(title: title, createdDate: date)
        modelContext.insert(newItem)
        category.items.append(newItem)
        saveContent()
        fetchItems()
    }
    
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
    
    
    func toggleItem(_ item: Item)
    {
        item.isDone.toggle()
        saveContent()
    }
 
    // (D)ELETE
    func deleteItem(_ item: Item, from category: Category? = nil)
    {
        guard let modelContext = modelContext else {return}
        
        if let category = category
        {
            category.items.removeAll{$0.id == item.id}
        }
        
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
    
    func updateItemTitle(_ item: Item, newTitle: String)
    {
        let trimmed = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {return}
        item.title = trimmed
        saveContent()
        fetchItems()
    }
}
