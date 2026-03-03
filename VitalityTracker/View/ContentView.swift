//
//  ContentView.swift
//  CI6330 Todo Swift UI
//
//  Created by Sajid, Abdullah on 20/01/2026.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    @StateObject private var controller = HabitListController()
    var body: some View {
        if hasSeenOnboarding
        {
            CategoryView()
        }
        else
        {
            HomeView()
        }
            
        
        
    }
}

#Preview {
    ContentView()
}
