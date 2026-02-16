//
//  Item.swift
//  CI6330 Todo Swift UI
//
//  Created by Sajid, Abdullah on 27/01/2026.
//

import SwiftUI
import SwiftData

@Model
class Item{
    var id: UUID
    var title: String = ""
    var isDone: Bool
    
    init (title: String)
    {
        self.id = UUID()
        self.title = title
        self.isDone = false
    }
}




