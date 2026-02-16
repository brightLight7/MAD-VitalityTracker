//
//  Category.swift
//  CI6330 Todo Swift UI
//
//  Created by Sajid, Abdullah on 03/02/2026.
//

import SwiftUI
import SwiftData

@Model
class Category
{
    var id: UUID = UUID()
    var name: String
    var items: [Item]
    
    init (name: String)
    {
        self.id = UUID()
        self.name = name
        self.items = []
    }
}
