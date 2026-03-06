// Intended for instructions for the user when they have not yet made a category or a habit.

import SwiftUI

struct EmptyStateView : View {
    let title: String
    let message: String
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 11)
        {
            Image(systemName: systemImage)
                .font(.system(size: 36))
            
            Text(title)
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}
