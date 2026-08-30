//
//  EJSignIn.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 11/10/24.
//

import SwiftUI
struct EJSignIn: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    var body: some View {
        NavigationStack {
        ZStack{
            
                VStack {
                    Text("Sign In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Sign In") {
                        viewModel.signIn()
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
                .alert("Sign In Failed", isPresented: errorAlert, actions: { Button("OK", role: .cancel) {} }, message: { Text(viewModel.errorMessage ?? "") })
            }
        .background(EJUtility.shared.getTheme())
        }
        .onChange(of: viewModel.isAuthenticated) { _, authenticated in if authenticated { isLoggedIn = true } }
    }
    private var errorAlert: Binding<Bool> { Binding(get: { viewModel.errorMessage != nil }, set: { if !$0 { viewModel.errorMessage = nil } }) }
}


#Preview {
    EJSignIn()
}
