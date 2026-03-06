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
    
    @State private var completionFiltering: CompletionFiltering = .all
    
    @State private var titleSort: TitleSorting = .az
    
    
    var body: some View {
        
        
        NavigationSplitView
        {
            Group
            {
                if controller.categories.isEmpty
                {
                    VStack(spacing: 12)
                    {
                        EmptyStateView(title: "No Categories yet", message: "Tap the + button to create your first categories to store your habits in!", systemImage: "square.grid.2x2")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                }
                else
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
                    
                }
               
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    SortFilterMenu(habitListPage: false, completionFiltering: $completionFiltering, titleSort: $titleSort)
                }
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    
                    Button(action:  {
                        showAdd = true
                    }){
                        Label("Add Category", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    DarkModeToolbarButton()
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
