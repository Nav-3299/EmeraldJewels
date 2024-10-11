//
//  EJSignIn.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 11/10/24.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct EJSignIn: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    @State var gotoHomePage = false
    var body: some View {
        NavigationStack {
        ZStack{
            
                VStack {
                    Text("Sign In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    TextField("Email", text: $email)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Sign In") {
                        signIn()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    
                    NavigationLink("Don't have an account? Sign Up", destination: EJSignUp())
                        .foregroundStyle(.white)
                    
                }
                .padding()
                .navigationDestination(isPresented: $gotoHomePage, destination: {
                    EJHomeView()
                        .navigationBarBackButtonHidden()
                })
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        .background(EJUtility.shared.getTheme())
        }
       
        
    }

    private func signIn() {
        // Only perform Firebase sign-in when NOT in Preview mode
            #if !targetEnvironment(simulator)
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        print("Error signing in: \(error.localizedDescription)")
                        self.alertMessage = error.localizedDescription
                        self.showAlert = true
                        self.gotoHomePage = false
                    } else {
                        print("Signed in!")
                        self.gotoHomePage = true
                        isLoggedIn = true
                        self.showAlert = false
                    }
                }
            }
            #endif
    }
}


#Preview {
    EJSignIn()
}
