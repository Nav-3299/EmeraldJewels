//
//  EJDescriptionView.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 10/10/24.
//

import SwiftUI

struct EJDescriptionView: View {
    @Binding var jewelleryProduct: JewelleryProduct!
    
    @State private var showUserDetails = false
    @State private var showCODView = false

    var body: some View {
        ZStack {
            VStack {
                EJUtility.shared.getLogoView()
                BannerImage
                
                Text("Details")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                Details
                Spacer()
                
                BuyNow
            }
        }
        .background(EJUtility.shared.getTheme())
        .fullScreenCover(isPresented: $showUserDetails) {
            EJUserDetailsView(showUserDetails: $showUserDetails, showCODView: $showCODView)
        }
        .fullScreenCover(isPresented: $showCODView) {
            EJCodView(showCODView: $showCODView, jewelleryProduct: jewelleryProduct)
        }
    }
}

#Preview {
    // Create a temporary state variable to use for preview
    struct PreviewWrapper: View {
        @State private var jewels: JewelleryProduct? = JewelleryProduct(id: 1, name: "Name", description: "Description", price: 1234.0, currency: "USD", imageUrl: "EJ1 0")

        var body: some View {
            EJDescriptionView(jewelleryProduct: $jewels)
        }
    }

    return PreviewWrapper()
}

extension EJDescriptionView {
    private var BannerImage: some View {
        Image(jewelleryProduct.imageUrl ?? "")
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: 300)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var Details: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Name   ")
                Spacer()
                Text("\(jewelleryProduct.name ?? "Name")")
                    .frame(alignment: .trailing)
            }
            HStack {
                Text("Price   ")
                Spacer()
                Text("\(jewelleryProduct.price ?? 0)")
                    .frame(alignment: .trailing)
            }
            HStack {
                Text("Description   ")
                Spacer()
                Text("\(jewelleryProduct.description ?? "description")")
                    .frame(alignment: .trailing)
            }
            HStack {
                Text("Currency   ")
                Spacer()
                Text("\(jewelleryProduct.currency ?? "Currency")")
                    .frame(alignment: .trailing)
            }
        }
        .foregroundStyle(.white)
        .padding()
        .font(.caption)
        .fontWeight(.bold)
    }
    
    private var BuyNow: some View {
        Button(action: {
            showUserDetails.toggle() // Show User Details View
        }, label: {
            Text("Buy Now")
                .frame(maxWidth: .infinity, maxHeight: 20)
                .padding()
                .background(Color.purple)
                .clipShape(Capsule())
                .foregroundStyle(.white)
                .fontWeight(.bold)
        })
    }
}
