import SwiftUI

struct EJUserDetailsView: View {
    @ObservedObject var viewModel: CheckoutViewModel
    @Binding var showConfirmation: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Your Details").font(.title)
            TextField("Name", text: $viewModel.name).textFieldStyle(.roundedBorder)
            TextField("Address", text: $viewModel.address).textFieldStyle(.roundedBorder)
            Button("Proceed to Checkout") {
                if viewModel.continueToConfirmation() { dismiss(); showConfirmation = true }
            }.buttonStyle(.borderedProminent).tint(.purple)
        }
        .padding()
        .alert("Details needed", isPresented: validationAlert, actions: { Button("OK", role: .cancel) {} }, message: { Text(viewModel.validationMessage ?? "") })
    }
    private var validationAlert: Binding<Bool> { Binding(get: { viewModel.validationMessage != nil }, set: { if !$0 { viewModel.validationMessage = nil } }) }
}
