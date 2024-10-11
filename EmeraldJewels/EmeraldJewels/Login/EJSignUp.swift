//
//  EJSignUp.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 11/10/24.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct EJSignUp: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State var gotToHomePage = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    var body: some View {
        ZStack{
            VStack {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                TextField("Email", text: $email)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: $password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Sign Up") {
                    signUp()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
                
                NavigationLink("Already have an account? Sign In", destination: EJSignIn())
            }
            .padding()
            .navigationDestination(isPresented: $gotToHomePage, destination: {
                EJHomeView()
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .background(EJUtility.shared.getTheme())
    }

    private func signUp() {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
                gotToHomePage = false
            } else {
                // Handle successful sign-up
                gotToHomePage = true
                isLoggedIn = true
            }
        }
    }
}


#Preview {
    EJSignUp()
}
