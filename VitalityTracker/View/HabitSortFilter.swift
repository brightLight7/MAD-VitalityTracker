import Foundation

enum CompletionFiltering: String, CaseIterable, Identifiable
{
    case all = "All"
    case completed = "Completed"
    case incomplete = "Incomplete"
    
    var id: String {rawValue}
}

enum TitleSorting: String, CaseIterable, Identifiable
{
    case az = "A → Z"
    case za = "Z → A"
    
    var id: String {rawValue}
}

enum HabitSortFilter
{
    static func apply(
        items: [Item],
        viewingDate: Date,
        completionFilter: CompletionFiltering,
        titleSort: TitleSorting,
        isCompleted: (UUID, Date) -> Bool
    ) -> [Item]
    {
        let selectedDate = Calendar.current.startOfDay(for: viewingDate)
        
        var result = items.filter{$0.createdDate <= selectedDate}
        
        result = result.filter
        {
            item in let done = isCompleted(item.id, viewingDate)
            switch completionFilter
            {
            case .all:
                return true
            case .completed:
                return done
            case .incomplete:
                return !done
            }
        }
        result = result.sorted
        {
            switch titleSort
            {
            case .az:
                return $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            case .za:
                return $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedDescending
            }
            
        }
        return result
    }
}
