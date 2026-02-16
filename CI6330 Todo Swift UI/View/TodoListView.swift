import SwiftUI
import SwiftData

struct TodoListView: View {
    let category: Category
    @Environment(\.modelContext) private var modelContext
    @StateObject private var controller = ToDoListController()
    @State private var showAdd: Bool = false
    @State private var newItem: String = ""
    @State private var searchQuery: String = ""
    var body: some View
    {
        NavigationSplitView
        {
            VStack
            {
                TextField("Search todos...", text: $searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            List
            {
                ForEach(controller.filteredCatItems(for: category, searchQuery: searchQuery), id: \.id)
                {
                    item in HStack
                    {
                        Text(item.title)
                            .fontWeight(item.isDone ? .bold : .regular)
                        Spacer()
                        Image(systemName: item.isDone ? "checkmark" : "square")
                    }
                    .contentShape(Rectangle())
                    .onTapGesture{
                        controller.toggleItem(item)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet
                    {
                        let item = controller.todoItems[index]
                        controller.deleteItem(item)
                    }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    Button(action: {
                        showAdd = true
                    })
                    {
                        Label("Add Item", systemImage: "plus")
                    }
                    
                }
            }
            .alert("Add Todo", isPresented: $showAdd){
                TextField("Enter new todo", text: $newItem)
                Button("Add")
                {
                    controller.addItem(title: newItem, to: category)
                    newItem = ""
                }
                Button("Not now", role: .cancel) {
                    newItem = ""
                }
            }message: {
                Text("Enter a new task to add to the list")
            }
            .navigationTitle(category.name)
        }
        
    detail:
        {
            Text("Todos")
        }
        .onAppear
        {
            controller.setModelContext(modelContext)
        }
    }
    
}
#Preview {
    TodoListView(category: Category(name: "Sample"))
        .modelContainer(for: Item.self, inMemory: true)
}
