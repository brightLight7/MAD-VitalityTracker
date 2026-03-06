import SwiftUI

class ThemeManager : ObservableObject
{
    @AppStorage("forceDarkMode") var forceDarkMode: Bool = false
    {
        willSet {objectWillChange.send()}
    }
    
    var preferredColorScheme: ColorScheme?
    {
        forceDarkMode ? .dark : nil
    }
    
    func toggleDarkMode()
    {
        forceDarkMode.toggle()
    }
}
