import SwiftUI
import SwiftData

struct HabitListView: View {
    let category: Category
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var controller: HabitListController
    @EnvironmentObject var streaksController: StreaksController
    
    @State private var selectedItem: Item?
    @State private var showEditSheet = false
    @State private var showQuickRename = false
    @State private var quickRenameText = ""
    @State private var showAdd = false
    @State private var newItem: String = ""
    @State private var searchQuery: String = ""
    @State private var viewingDate: Date = Date()

    //@State private var habitBeingEdited: Item?
    
    @State private var completionFiltering: CompletionFiltering = .all
    
    @State private var titleSort: TitleSorting = .az
    
    private var dateTitle: String
    {
        let df = DateFormatter()
        df.dateStyle = .full
        return df.string(from: Calendar.current.startOfDay(for: viewingDate))
    }
    
//    private func displayedItems() -> [Item]
//    {
//        
//    }
    
    var body: some View
    {
        let base = controller.filteredCatItems(for: category, searchQuery: searchQuery)
        
        let items = HabitSortFilter.apply(items: base, viewingDate: viewingDate, completionFilter: completionFiltering, titleSort: titleSort, isCompleted:
                                            {
            id, date in
            streaksController.isCompleted(id, on: date)
        }
        )
        return VStack
        {
            TextField("Search habits...", text: $searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            DateBar(viewingDate: $viewingDate, isToday: Calendar.current.isDateInToday(viewingDate), dateTitle: dateTitle)
            
            if items.isEmpty
            {
                Spacer()
                
                EmptyStateView(title: "No Habits made", message: "Tap the + button to create your first habit!", systemImage: "checklist")
                
                Spacer()
                
            }
            else
            {
                
                List
                {
                    
                    ForEach(items, id: \.id)
                    {
                        item in HabitRowView(item: item, viewingDate: viewingDate, onTap: {selectedItem = item; showEditSheet = true})
                        
                            .swipeActions(edge: .leading, allowsFullSwipe: true)
                        {
                            Button
                            {
                                selectedItem = item
                                quickRenameText = item.title
                                showQuickRename = true
                            }label:
                            {
                                Label( "Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true)
                        {
                            Button (role: .destructive)
                            {
                                controller.deleteItem(item, from: category)
                            }label:
                            {
                                Label ("Delete", systemImage: "trash")
                            }
                        }
                    }
//                    .onDelete { indexSet in
//                        for index in indexSet.sorted(by: >)
//                        {
//                            let item = items[index]
//                            controller.deleteItem(item, from: category)
//                        }
//                    }
                }
            }
        }
                .navigationTitle(category.name)
                .toolbar
            {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    SortFilterMenu(habitListPage: true, completionFiltering: $completionFiltering, titleSort: $titleSort)
                    
                }
                
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    Button
                    {
                        showAdd = true
                    } label:
                    {
                        Label("Create habit", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    DarkModeToolbarButton()
                }
            }.alert("Add Habit", isPresented: $showAdd){
                TextField("Enter new habit", text: $newItem)
                Button("Add")
                {
                    controller.addItem(title: newItem, to: category, createdOn: viewingDate)
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
        message:
            {
                Text("Enter a new habit to add to the list")
            }
            .onAppear
            {
                
                controller.setModelContext(modelContext)
            }
        }
    
    
}
