//
//  CategoryView.swift
//  CI6330 Todo Swift UI
//
//  Created by Sajid, Abdullah on 03/02/2026.
//

import SwiftUI
import SwiftData

struct CategoryView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var controller = CategoryController()
    @StateObject private var habitController = HabitListController()
    @State private var newCat: String = ""
    @State private var showAdd: Bool = false
    @State private var selectedCategory: Category?
    
    
    var body: some View {
        NavigationSplitView
        {
            List
            {
                ForEach(controller.categories, id: \.id) { cat in
                    NavigationLink(destination: HabitListView(category: cat).environmentObject(habitController), label: { Text(cat.name) })
                }
                .onDelete
                {
                    indexSet in
                    for index in indexSet
                    {
                        let cat = controller.categories[index]
                        controller.deleteCategory(cat)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    Button(action:  {
                        showAdd = true
                    }){
                        Label("Add Category", systemImage: "plus")
                    }
                }
            }
            .alert("Add Category", isPresented: $showAdd){
                TextField("Enter new todo", text: $newCat)
                Button("Add")
                {
                    controller.addCategory(name: newCat)
                    newCat = ""
                }
                Button("Not now", role: .cancel) {
                    newCat = ""
                }
            }message: {
                Text("Enter a new task to add to the list.")
            }
            .navigationTitle("Categories")
        } detail: {
            Text("Select a Category")
        }
        .onAppear
        {
            controller.setModelContext(modelContext)
            habitController.setModelContext(modelContext)
        }
    }
}

#Preview {
    CategoryView()
        .modelContainer(for: [Item.self, Category.self], inMemory: true)
}
