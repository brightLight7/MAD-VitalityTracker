//
//  CategoryController.swift
//  CI6330 Todo Swift UI
//
//  Created by Sajid, Abdullah on 03/02/2026.
//

import SwiftUI
import SwiftData

class CategoryController: ObservableObject
{
    private var modelContext: ModelContext?
    @Published var categories: [Category] = []
    
    init(modelContext: ModelContext? = nil)
    {
        self.modelContext = modelContext
        fetchCategories()
    }
    
    func setModelContext(_ context: ModelContext)
    {
        modelContext = context
        fetchCategories()
    }
    
    func fetchCategories()
    {
        guard let modelContext = modelContext else {return}
        do
        {
            categories = try modelContext.fetch(FetchDescriptor<Category>())
            
        }
        catch
        {
            print("Failed to fetch items: \(error)")
        }
    }
    
    func addCategory( name: String)
    {
        guard let modelContext = modelContext else {return}
        let newCategory = Category(name: name)
        modelContext.insert(newCategory)
        fetchCategories()
    }
 
    // (D)ELETE
    func deleteCategory(_ category: Category)
    {
        guard let modelContext = modelContext else {return}
        modelContext.delete(category)
        fetchCategories()
    }
}
