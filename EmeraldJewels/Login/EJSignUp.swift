//
//  EJSignUp.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 11/10/24.
//

import SwiftUI
struct EJSignUp: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    var body: some View {
        ZStack{
            VStack {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Sign Up") {
                    viewModel.signUp()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
                
                NavigationLink("Already have an account? Sign In", destination: EJSignIn())
            }
            .padding()
            .alert("Sign Up Failed", isPresented: errorAlert, actions: { Button("OK", role: .cancel) {} }, message: { Text(viewModel.errorMessage ?? "") })
        }
        .background(EJUtility.shared.getTheme())
        .onChange(of: viewModel.isAuthenticated) { _, authenticated in if authenticated { isLoggedIn = true } }
    }
    private var errorAlert: Binding<Bool> { Binding(get: { viewModel.errorMessage != nil }, set: { if !$0 { viewModel.errorMessage = nil } }) }
}


#Preview {
    EJSignUp()
}
