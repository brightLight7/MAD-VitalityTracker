import SwiftUI
import SwiftData

struct HabitListView: View {
    let category: Category
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var controller: HabitListController
    @EnvironmentObject var streaksController: StreaksController
    
    @State private var selectedItem: Item? = nil
    @State private var showEditSheet = false
    @State private var showQuickRename = false
    @State private var quickRenameText = ""
    
    @State private var showAdd: Bool = false
    @State private var newItem: String = ""
    @State private var searchQuery: String = ""
    @State private var viewingDate: Date = Date()
    
    private var isToday: Bool
    {
        Calendar.current.isDateInToday(viewingDate)
    }
    
    private var dateTitle: String
    {
        let df = DateFormatter()
        df.dateStyle = .full
        return df.string(from: Calendar.current.startOfDay(for: viewingDate))
    }
    
    var displayedItems: [Item]{
        let base = controller.filteredCatItems(for: category, searchQuery: searchQuery)
        
        let selectedDate = Calendar.current.startOfDay(for: viewingDate)
        
        return base.filter
        {
            $0.createdDate <= selectedDate
        }
    }
    
    private var dayBar: some View
    {
        HStack(spacing: 12)
        {
            Button
            {
                viewingDate = Calendar.current.date(byAdding: .day, value: -1, to: viewingDate) ?? viewingDate
            } label:
            {
                Image(systemName: "chevron.left")
                Text("Prev")
            }
            
            Spacer()
            
            VStack(spacing: 2)
            {
                Text(dateTitle).font(.headline)
                if !isToday
                {
                    Text("Read-only").font(.caption).foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Button
            {
                viewingDate = Calendar.current.date(byAdding: .day, value: 1, to: viewingDate) ?? viewingDate
            } label:
            {
                Text("Next")
                Image(systemName: "chevron.right")
            }
            .disabled(isToday)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    var body: some View
    {
        VStack
        {
            TextField("Search habits...", text: $searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
        }
        
        dayBar
        
        List
        {
            
            
            ForEach(displayedItems, id: \.id)
            {
                (item: Item) in
                let done = streaksController.isCompleted(item.id, on: viewingDate)
                let s = streaksController.streak(for: item, endingOn: viewingDate)
                
                HStack (spacing: 12)
                {
                    Button
                    {
                        streaksController.toggleCompletion(item.id, on: viewingDate)
                    }
                label:
                    {
                        Image(systemName: done ? "checkmark.square.fill" : "square")
                            .font(.title3)
                    }
                    .buttonStyle(.plain)
                    
                    Text(item.title)
                        .strikethrough(done)
                    
                    Spacer()
                    if s > 0
                    {
                        HStack(spacing: 4)
                        {
                            Text("🔥")
                            Text("\(s)")
                                .font(.caption)
                                .bold()
                                .foregroundStyle(.orange)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                        
                    }
                    
                    
                }
                .contentShape(Rectangle())
                .onTapGesture{
                    //guard isToday else {return} // read-only for previous days
                    selectedItem = item
                    showEditSheet = true
                }
                //.opacity(isToday ? 1 : 0.85)
                .onLongPressGesture
                {
                    selectedItem = item
                    quickRenameText = item.title
                    showQuickRename = true
                }
            }
            .onDelete { indexSet in
                for index in indexSet.sorted(by: >)
                {
                    let item = displayedItems[index]
                    controller.deleteItem(item, from: category)
                }
            }
        }
        .navigationTitle(category.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing)
            {
                Button(action: {
                    showAdd = true
                })
                {
                    Label("Create habit", systemImage: "plus")
                }
                
            }
        }
        .alert("Add Habit", isPresented: $showAdd){
            TextField("Enter new habit", text: $newItem)
            Button("Add")
            {
                controller.addItem(title: newItem, to: category)
                newItem = ""
            }
            Button("Not now", role: .cancel) {
                newItem = ""
            }
        }
        .sheet(isPresented: $showEditSheet)
        {
            if let selectedItem
            {
                HabitSheet(
                    item: selectedItem,
                    onSave: {newTitle in
                        controller.updateItemTitle(selectedItem, newTitle: newTitle)}
                )
            }
        }
        .alert("Rename Habit", isPresented: $showQuickRename)
        {
            TextField("habit title", text: $quickRenameText)
            Button("Cancel", role: .cancel) {}
            Button("Save")
            {
                if let selectedItem
                {
                    controller.updateItemTitle(selectedItem, newTitle: quickRenameText)
                }
            }
        }
        message: {
            Text("Enter a new habit to add to the list")
        }
        //.navigationTitle(category.name)
        .onAppear
        {
            
            controller.setModelContext(modelContext)
            // viewingDate = Date()
        }
        .navigationTitle(category.name)
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: [Category.self, Item.self], inMemory: true)
}











