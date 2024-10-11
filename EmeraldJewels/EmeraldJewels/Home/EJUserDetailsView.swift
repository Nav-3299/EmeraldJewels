//
//  EJUserDetailsView.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 11/10/24.
//

import SwiftUI


struct EJUserDetailsView: View {
    @Binding var showUserDetails: Bool
    @Binding var showCODView: Bool
    @State private var name: String = ""
    @State private var address: String = ""

    var body: some View {
        VStack {
            // Cross Button
            HStack {
         
                Button(action: {
                    hideView()
                }) {
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.red)
                        .padding()
                }
                .padding(.top, 10)
            }
 
            
            Text("Enter Your Details")
                .font(.title)
                .padding()

            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Address", text: $address)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Proceed to Checkout") {
                // Validate the input here if necessary
                showCODView.toggle()  // Show COD View
                showUserDetails = false // Dismiss User Details View
            }
            .padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
    
    func hideView() {
        showUserDetails = false
    }
}


#Preview {
    struct PreviewWrapper : View {
        @State var EJshowUserDetails = true
        @State var EJshowCODView = false
        var body: some View {
            EJUserDetailsView( showUserDetails : $EJshowUserDetails, showCODView: $EJshowCODView)
        }
    }
    return PreviewWrapper()
   
}
