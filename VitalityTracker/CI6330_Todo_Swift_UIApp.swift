//
//  CI6330_Todo_Swift_UIApp.swift
//  CI6330 Todo Swift UI
//
//  Created by Sajid, Abdullah on 20/01/2026.
//

import SwiftUI
import SwiftData

@main
struct CI6330_Todo_Swift_UIApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Category.self,
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        }
        catch
        {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup{
            CategoryView()        }
        .modelContainer(sharedModelContainer)
    }
}
