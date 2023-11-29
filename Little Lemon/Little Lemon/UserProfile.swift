import SwiftUI

struct UserProfile: View {
    
    // Constants to hold user information from UserDefaults
    private let firstName: String
    private let lastName: String
    private let email: String
    
    init() {
        // Access UserDefaults to retrieve user information
        self.firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
        self.lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
        self.email = UserDefaults.standard.string(forKey: kEmail) ?? ""
    }
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack {
            // Display user information
            Image("profile-image-placeholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding()
            
            Text("First Name: \(firstName)")
                .font(.headline)
            
            Text("Last Name: \(lastName)")
                .font(.headline)
            
            Text("Email: \(email)")
                .font(.headline)
            
            // Logout Button
            Button("Logout") {
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                self.presentation.wrappedValue.dismiss()
            }
            .padding()
            
            // Spacer to align items at the top
            Spacer()
        }
        .padding()
        .navigationBarTitle("User Profile")
    }
}
