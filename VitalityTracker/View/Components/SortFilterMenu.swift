import SwiftUI

struct SortFilterMenu: View {
    let habitListPage: Bool
    
    @Binding var completionFiltering: CompletionFiltering
    @Binding var titleSort: TitleSorting
    var body: some View {
        Menu{
            if habitListPage
            {
                Section("Filter") {
                    Picker("Completion", selection: $completionFiltering)
                    {
                        ForEach(CompletionFiltering.allCases, id: \.self) {
                            option in Text(option.rawValue).tag(option)
                        }
                    }
                }
            }
            
            
            Section("Sort") {
                Picker("Title", selection: $titleSort) {
                    ForEach(TitleSorting.allCases) {
                        option in Text(option.rawValue).tag(option)
                    }
                }
            }
        }label:{
            Label("Sort & Filter", systemImage: "line.3.horizontal.decrease.circle")
        }
        
    }
    
}

