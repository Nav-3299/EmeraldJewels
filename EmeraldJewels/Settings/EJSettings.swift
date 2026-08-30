//
//  EJSettings.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 11/10/24.
//

import SwiftUI

struct EJSettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
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
            .onAppear(perform: viewModel.loadProfile)
            .alert("Logout failed", isPresented: errorAlert, actions: { Button("OK", role: .cancel) {} }, message: { Text(viewModel.errorMessage ?? "") })
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
            Text(viewModel.userEmail)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
    }
    
    private var LogoutButton: some View {
        Button(action: {
            if viewModel.logout() { isLoggedIn = false }
        }) {
            Text("Logout")
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    private var errorAlert: Binding<Bool> { Binding(get: { viewModel.errorMessage != nil }, set: { if !$0 { viewModel.errorMessage = nil } }) }
}

#Preview {
    EJSettingsView()
}
