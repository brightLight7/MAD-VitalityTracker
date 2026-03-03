
import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    var body: some View {
        if hasSeenOnboarding
        {
            CategoryView()
            
        }
        else
        {
            HomeView()
        }
    }
}
#Preview {
    ContentView()
}
