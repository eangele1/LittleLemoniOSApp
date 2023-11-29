import SwiftUI

struct Menu: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title of the application
            Text("My Restaurant App")
                .font(.title)
            
            // Restaurant location
            Text("Location: Chicago")
                .font(.subheadline)
            
            // Short description
            Text("Welcome to our amazing restaurant app! Explore our menu and enjoy a variety of delicious dishes.")
                .font(.body)
            
            // Empty List for menu items
            List {
                // This list will be populated with menu items later
            }
        }
        .padding()
    }
}
