import SwiftUI
import SwiftData

struct HelpSheet: View
{
    let item: Item
    let onSave: (String) -> Void
    
    @State private var titleText: String
    @Environment(\.dismiss) private var dismiss
    
    init(item: Item, onSave: @escaping (String) -> Void) {
        self.item = item
        self.onSave = onSave
        _titleText = State(initialValue: item.title)
        
    }
    
    var body: some View
    {
        NavigationStack
        {
            Section("Help")
            {
                TextField("Title", text: $titleText)
            }
            Section("Text Body")
            {
                TextField("The + icon is for creating a new habit", text: $titleText)
            }
        }
    }
    
    
}

