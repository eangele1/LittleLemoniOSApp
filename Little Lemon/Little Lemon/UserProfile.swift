import SwiftUI

struct UserProfile: View {
    
    // Constants to hold user information from UserDefaults
    @State private var firstName: String
    @State private var lastName: String
    @State private var email: String
    @State private var phoneNumber: String
    
    @State private var isOption1Selected = false
    @State private var isOption2Selected = false
    @State private var isOption3Selected = false
    @State private var isOption4Selected = false
    
    init() {
        _firstName = State(initialValue: UserDefaults.standard.string(forKey: kFirstName) ?? "")
        _lastName = State(initialValue: UserDefaults.standard.string(forKey: kLastName) ?? "")
        _email = State(initialValue: UserDefaults.standard.string(forKey: kEmail) ?? "")
        _phoneNumber = State(initialValue: UserDefaults.standard.string(forKey: kPhoneNumber) ?? "")
    }
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        ZStack{
            ScrollView{
                VStack(spacing: 0) {
                    NavigationBarView()
                    VStack {
                        Image("profile-image-placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .padding()
                        
                        HStack {
                            Button("Change") {
                                // TODO
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(hex: "495E57"))
                            .cornerRadius(10)
                            
                            Button("Remove") {
                                // TODO
                            }
                            .padding()
                            .foregroundColor(.black)
                            .cornerRadius(10)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("First Name:")
                            .font(.headline)
                        TextField("Enter First Name", text: $firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Last Name:")
                            .font(.headline)
                        TextField("Enter Last Name", text: $lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Email:")
                            .font(.headline)
                        TextField("Enter Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Phone Number:")
                            .font(.headline)
                        TextField("Enter Phone Number", text: $phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding()
                    
                    // Email Notifications Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Email Notifications:")
                            .font(.headline)
                        
                        Toggle("Order Statuses", isOn: $isOption1Selected)
                        Toggle("Password Changes", isOn: $isOption2Selected)
                        Toggle("Special Offers", isOn: $isOption3Selected)
                        Toggle("Newsletter", isOn: $isOption4Selected)
                    }
                    .padding()
                    
                    // Logout Button
                    Button("Log out") {
                        UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                        self.presentation.wrappedValue.dismiss()
                    }
                    .padding()
                    .foregroundColor(.black)
                    .background(Color(hex: "F4CE14"))
                    .cornerRadius(10)
                    
                    // Spacer to align items at the top
                    Spacer()
                    
                    // Save and Discard Buttons
                    HStack {
                        Button("Discard Changes") {
                            // TODO
                        }
                        .padding()
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        
                        
                        Spacer()
                        
                        Button("Save Changes") {
                            // TODO
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(hex: "495E57"))
                        .cornerRadius(10)
                        
                    }
                    .padding()
                }
                .padding()
            }
            
        }
    }
}
