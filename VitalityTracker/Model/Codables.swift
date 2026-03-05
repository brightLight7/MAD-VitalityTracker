////
////  Codables.swift
////  CI6330 Todo Swift UI
////
////  Created by Sajid, Abdullah on 27/01/2026.
////
//
//import SwiftUI
//
//class Codables{
//    
//    func loadItem()
//    {
//        if let data = try? Data(contentsOf: URL(fileURLWithPath: "/tmp/todos.plist"))
//            do{
//            todoItems = try decoder.decode([Item].self, from: data)
//            }
//        catch{
//            print("Error decoding items \(error)")
//        }
//    }
//    
//    func saveItems()
//    {
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(todoItems)
//            let fileURL = URL(fileURLWithPath: "/tmp/todos.plist")
//            try data.write(to: fileURL)
//            print(fileURL)
//        }
//        catch
//        {
//            print("Error encoding items: `\(error)")
//        }
//    }
//    
//    
//}
//
