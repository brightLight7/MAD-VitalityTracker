//
//  ContentView.swift
//  CI6330 Todo Swift UI
//
//  Created by Sajid, Abdullah on 20/01/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var controller = HabitListController()
    var body: some View {
        
            CategoryView()
        
        
    }
}

#Preview {
    ContentView()
}
