//
//  EJCodView.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 11/10/24.
//

import SwiftUI

import SwiftUI

struct EJCodView: View {
    @Binding var showCODView: Bool
    @State var ButtonLabel = "Confirm Order"
    @State var ButtonColor = Color.purple
    var jewelleryProduct: JewelleryProduct

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
 
            Text("Confirm Your Order")
                .font(.title)
                .padding()

            Text("Product:" + "\(jewelleryProduct.name ?? "name")")
            Text("Price: " + "\(jewelleryProduct.price ?? 0.00)" + "\(jewelleryProduct.currency ?? "INR")")

            Button(ButtonLabel) {
                // Handle the order confirmation logic here
                ButtonLabel = "OrderPlaced"
                ButtonColor = Color.green
                // For now, just dismiss the view
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    showCODView = false
                }
            }
            .padding()
            .background(ButtonColor)
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
        showCODView = false
    }
   
}


#Preview {
    struct PreviewWrapper: View {
        @State private var showCODView = true // Set to true to display the CODView in preview
        let sampleJewelleryProduct = JewelleryProduct(id: 1, name: "Sample Necklace", description: "Beautiful gold necklace", price: 1500.00, currency: "USD", imageUrl: "EJ1 0")

        var body: some View {
            EJCodView(showCODView: $showCODView, jewelleryProduct: sampleJewelleryProduct)
        }
    }

    return PreviewWrapper()
}

