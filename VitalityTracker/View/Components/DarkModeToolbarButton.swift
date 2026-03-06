import SwiftUI

struct DarkModeToolbarButton : View {
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        Button
        {
            themeManager.toggleDarkMode()
        }
    label:
        {
            Image(systemName: themeManager.forceDarkMode ? "moon.fill" : "moon")
        }
        
    }
}
