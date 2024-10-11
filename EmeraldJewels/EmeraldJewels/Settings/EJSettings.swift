//
//  EJSettings.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 11/10/24.
//

import SwiftUI

import SwiftUI
import FirebaseAuth

struct EJSettingsView: View {
    @State private var userEmail: String = ""
    @State private var showAlert = false
    @State private var isLoggedOut = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Profile Section
                ProfileSection
                
                // Logout Button
                LogoutButton
                
                Spacer()
            }
            .padding()
            .onAppear {
                loadUserProfile()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Logout Successful"),
                      message: Text("You have been logged out."),
                      dismissButton: .default(Text("OK")))
            }
            .navigationDestination(isPresented: $isLoggedOut) {
                EJSignIn() // Navigate to the login screen after logout
            }
        }
    }
    
    private var ProfileSection: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
                .padding()
            
            Text("User Email")
                .font(.headline)
                .foregroundColor(.gray)
            Text(userEmail)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
    }
    
    private var LogoutButton: some View {
        Button(action: {
            logoutUser()
        }) {
            Text("Logout")
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    // Load the user's profile information
    private func loadUserProfile() {
        if let user = Auth.auth().currentUser {
            userEmail = user.email ?? "No Email"
        }
    }
    
    // Logout the user using Firebase Authentication
    private func logoutUser() {
#if !targetEnvironment(simulator)
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1"  {
            do {
                try Auth.auth().signOut()
                showAlert = true
                isLoggedIn = false
                isLoggedOut = true // Redirect to login view after successful logout
            } catch {
                print("Error logging out: \(error.localizedDescription)")
            }
        }
#endif
        
        
    }
}

#Preview {
    EJSettingsView()
}
