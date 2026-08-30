import SwiftUI

struct EJDescriptionView: View {
    let jewelleryProduct: JewelleryProduct
    @StateObject private var checkout = CheckoutViewModel()
    @State private var showDetails = false
    @State private var showConfirmation = false

    var body: some View {
        VStack {
            EJUtility.shared.getLogoView()
            Image(jewelleryProduct.imageUrl).resizable().scaledToFit().frame(maxHeight: 300).clipShape(RoundedRectangle(cornerRadius: 20))
            Text("Details").font(.title.bold()).foregroundStyle(.white)
            Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                GridRow { Text("Name"); Text(jewelleryProduct.name) }
                GridRow { Text("Price"); Text(jewelleryProduct.formattedPrice) }
                GridRow { Text("Description"); Text(jewelleryProduct.description) }
            }.foregroundStyle(.white).padding()
            Spacer()
            Button("Buy Now") { showDetails = true }.buttonStyle(.borderedProminent).tint(.purple).padding()
        }
        .background(EJUtility.shared.getTheme())
        .sheet(isPresented: $showDetails) { EJUserDetailsView(viewModel: checkout, showConfirmation: $showConfirmation) }
        .sheet(isPresented: $showConfirmation) { EJCodView(viewModel: checkout, jewelleryProduct: jewelleryProduct) }
    }
}

#Preview { EJDescriptionView(jewelleryProduct: JewelleryProduct(id: 1, name: "Necklace", description: "Gold", price: 100, currency: "USD", imageUrl: "EJ1 0")) }
