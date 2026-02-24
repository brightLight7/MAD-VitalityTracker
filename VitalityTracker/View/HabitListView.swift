import SwiftUI
import SwiftData

struct HabitListView: View {
    let category: Category
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var controller: HabitListController
    @State private var showAdd: Bool = false
    @State private var newItem: String = ""
    @State private var searchQuery: String = ""
    
    var displayedItems: [Item]{
        controller.filteredCatItems(for: category, searchQuery: searchQuery)
    }
    var body: some View
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
                item in HStack (spacing: 12)
                {
                    Image(systemName: controller.isHabitCompletedToday(item) ? "checkmark.square.fill": "square")
                        .onTapGesture {
                            controller.toggleCompletionToday(item)
                        }
//                    VStack(alignment: .leading, spacing: 4)
//                    {
//                        Text(item.title)
////                            .strikethrough(item.isDone) //Changed from original to allow for text to be striked when completed.
//                        
//                        Spacer()
//                        let s = controller.streak(for: item)
//                        
//                        HStack(spacing: 4){
//                            if s > 0
//                            {
//                                Text("🔥")
//                            }
//                            Text("\(s)")
//                                .font(.caption)
//                                .foregroundStyle(.secondary)
//                        }
//                        
//                    }
                    
                    HStack
                    {
                        Text(item.title)
                            .strikethrough(controller.isHabitCompletedToday(item))
                        Spacer()
                        let s = controller.streak(for: item)
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
                    
//                    Spacer()
                    //Image(systemName: item.isDone ? "checkmark" : "square")
                }
                .contentShape(Rectangle())
                .onTapGesture{
                    controller.toggleCompletionToday(item)
                }
            }
            .onDelete { indexSet in
                for index in indexSet
                {
                    let item = displayedItems[index]
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
        //.navigationTitle(category.name)
        .onAppear
        {
            
            controller.setModelContext(modelContext)
        }
        .navigationTitle(category.name)
    }

}
    

//#Preview {
//    TodoListView(category: Category(name: "Sample"))
//        .modelContainer(for: Item.self, inMemory: true)
//}

#Preview {
    ContentView()
        .modelContainer(for: [Category.self, Item.self], inMemory: true)
}











