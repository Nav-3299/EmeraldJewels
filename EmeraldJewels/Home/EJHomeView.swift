import SwiftUI

struct EJHomeView: View {
    @StateObject private var viewModel = JewelleryViewModel()
    @State private var selectedProduct: JewelleryProduct?

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                VStack {
                    EJUtility.shared.getLogoView()
                    catalogue
                    NavigationLink(destination: EJChatView()) {
                        Text("Hi, I am Pixi!").font(.headline.bold()).frame(maxWidth: .infinity).padding().background(.purple).clipShape(Capsule()).foregroundStyle(.white)
                    }.padding()
                }
                NavigationLink(destination: EJSettingsView()) { Image(systemName: "gear").font(.system(size: 24)).padding().foregroundStyle(.white) }
            }
            .background(EJUtility.shared.getTheme())
            .navigationDestination(item: $selectedProduct) { EJDescriptionView(jewelleryProduct: $0) }
            .alert("Catalogue unavailable", isPresented: errorAlert, actions: { Button("Retry", action: viewModel.loadJewelryProducts); Button("OK", role: .cancel) {} }, message: { Text(viewModel.errorMessage ?? "") })
        }
    }

    private var catalogue: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(viewModel.jewelleryProducts) { product in
                    Button { selectedProduct = product } label: {
                        Image(product.imageUrl).resizable().scaledToFill().frame(width: 160, height: 180).clipShape(RoundedRectangle(cornerRadius: 20)).overlay(alignment: .bottomTrailing) { Text(product.formattedPrice).font(.footnote).padding(5).background(.black.opacity(0.65)).clipShape(RoundedRectangle(cornerRadius: 5)).foregroundStyle(.white) }
                    }
                }
            }.padding()
        }
    }

    private var errorAlert: Binding<Bool> { Binding(get: { viewModel.errorMessage != nil }, set: { if !$0 { viewModel.errorMessage = nil } }) }
}

#Preview { EJHomeView() }
