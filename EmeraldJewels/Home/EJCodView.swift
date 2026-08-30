import SwiftUI

struct EJCodView: View {
    @ObservedObject var viewModel: CheckoutViewModel
    let jewelleryProduct: JewelleryProduct
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("Confirm Your Order").font(.title)
            Text("Product: \(jewelleryProduct.name)")
            Text("Price: \(jewelleryProduct.formattedPrice)")
            Button(viewModel.isOrderPlaced ? "Order Placed" : "Confirm Order") {
                viewModel.confirmOrder()
            }.buttonStyle(.borderedProminent).tint(viewModel.isOrderPlaced ? .green : .purple).disabled(viewModel.isOrderPlaced)
            if viewModel.isOrderPlaced { Button("Done") { dismiss() } }
        }.padding()
    }
}
