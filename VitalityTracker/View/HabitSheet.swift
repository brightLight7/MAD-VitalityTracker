import SwiftUI
import SwiftData

struct HabitSheet: View
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
            Form
            {
            Section("Habit Title")
                {
                    TextField("Title", text: $titleText)
                }
            }
            .navigationTitle("Edit Habit")
            .toolbar
            {
                ToolbarItem(placement: .cancellationAction)
                {
                    Button("Cancel") {dismiss()}
                }
                ToolbarItem(placement: .confirmationAction)
                {
                    Button("Save")
                    {
                        onSave(titleText)
                        dismiss()
                    }
                }
            }
        }
    }
    
    
}
