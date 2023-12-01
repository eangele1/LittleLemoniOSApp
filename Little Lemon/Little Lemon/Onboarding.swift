import SwiftUI

// Global Constants for UserDefaults keys
let kFirstName = "first_name_key"
let kLastName = "last_name_key"
let kEmail = "email_key"
let kIsLoggedIn = "kIsLoggedIn"
let kPhoneNumber = "kPhoneNumber"

struct Onboarding: View {
    
    // State variables
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var isLoggedIn: Bool = false
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: Home(),
                    isActive: $isLoggedIn
                ) {
                    EmptyView()
                }
                
                Image("logo")
                    .resizable()
                    .frame(width: 320, height: 80)
                
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Register") {
                    // Check if firstName, lastName, and email are not empty
                    if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty {
                        // Checks if the email is valid
                        if isValidEmail(email) {
                            // Stores data in UserDefaults
                            UserDefaults.standard.set(firstName, forKey: kFirstName)
                            UserDefaults.standard.set(lastName, forKey: kLastName)
                            UserDefaults.standard.set(email, forKey: kEmail)
                            UserDefaults.standard.set(true, forKey: kIsLoggedIn)
                            
                            // Navigates to the Home screen
                            isLoggedIn = true
                            
                            // Clear text fields
                            firstName = ""
                            lastName = ""
                            email = ""
                        } else {
                            // Handles invalid email
                            print("Invalid email address.")
                        }
                    } else {
                        // Handles empty fields
                        print("Please fill in all the fields.")
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color(hex: "495E57"))
                .cornerRadius(10)
                .onAppear {
                    if UserDefaults.standard.bool(forKey: kIsLoggedIn) {
                        isLoggedIn = true
                    }
                }
            }
            .padding()
        }
    }
    
    // Function to check if the email is valid (you can replace this with your validation logic)
    private func isValidEmail(_ email: String) -> Bool {
        return email.contains("@")
    }
}
