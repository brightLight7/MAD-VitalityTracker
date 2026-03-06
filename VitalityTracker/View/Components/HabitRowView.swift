import SwiftUI

struct HabitRowView: View
{
    let item: Item
    let viewingDate: Date
    let onTap: () -> Void
    let onLongPress: () -> Void
    
    @EnvironmentObject var streaksController: StreaksController
    
    private var done: Bool
    {
        streaksController.isCompleted(item.id, on: viewingDate)
    }
    
    private var s: Int
    {
        streaksController.streak(for: item, endingOn: viewingDate)
    }
    var body: some View
    {
        //        (item: Item) in
        //            let done = streaksController.isCompleted(item.id, on: viewingDate)
        //            let s = streaksController.streak(for: item, endingOn: viewingDate)
        
        HStack (spacing: 12)
        {
            Button
            {
                streaksController.toggleCompletion(item.id, on: viewingDate)
            }
        label:
            {
                Image(systemName: done ? "checkmark.square.fill" : "square")
                    .font(.title3)
            }
            .buttonStyle(.plain)
            
            Text(item.title)
                .strikethrough(done)
            
            Spacer()
            if s > 0
            {
                HStack(spacing: 4)
                {
                    Text("🔥")
                    Text("\(s)")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.orange)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.thinMaterial)
                .clipShape(Capsule())
                
            }
            
            
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .onLongPressGesture{onLongPress()}
//            .onTapGesture{
//                //guard isToday else {return} // read-only for previous days
//                selectedItem = item
//                showEditSheet = true
//            }
//            //.opacity(isToday ? 1 : 0.85)
//            .onLongPressGesture
//            {
//                selectedItem = item
//                quickRenameText = item.title
//                showQuickRename = true
//            }
        }
    
}
