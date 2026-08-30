import SwiftUI

struct EJChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var isPressing = false
    private var isCameraAvailable: Bool { UIImagePickerController.isSourceTypeAvailable(.camera) }

    var body: some View {
        VStack {
            EJUtility.shared.getAIAvatar()
            if viewModel.isLoading { ProgressView("Analysing your outfit...").padding() }
            ScrollView {
                if let image = viewModel.selectedImage { Image(uiImage: image).resizable().scaledToFit().frame(maxHeight: 300).clipShape(RoundedRectangle(cornerRadius: 25)) }
                if let outfit = viewModel.outfitType { Text("Outfit: \(outfit)").foregroundStyle(.white).padding(.top) }
                if !viewModel.responseText.isEmpty { Text(viewModel.responseText).padding().background(.gray.opacity(0.2)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundStyle(.white) }
            }
            Spacer()
            HStack(spacing: 36) {
                Button { viewModel.isImagePickerPresented = true } label: { Image(systemName: "photo.on.rectangle") }
                Button(action: viewModel.clearConversation) { Image(systemName: "stop.circle.fill").foregroundStyle(.red) }
                Button {} label: { Image(.microphone).resizable().frame(width: 48, height: 48).scaleEffect(isPressing ? 1.25 : 1) }
                    .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in isPressing = pressing; pressing ? viewModel.speechRecognizer.startRecording() : viewModel.speechRecognizer.stopRecording() }, perform: {})
                Button { viewModel.isCameraPresented = true } label: { Image(systemName: "camera.aperture") }.disabled(!isCameraAvailable)
            }.font(.title2).foregroundStyle(.white).padding()
        }
        .padding().background(EJUtility.shared.getTheme())
        .sheet(isPresented: $viewModel.isImagePickerPresented) { ImagePicker(selectedImage: $viewModel.selectedImage, sourceType: .photoLibrary) }
        .sheet(isPresented: $viewModel.isCameraPresented) { ImagePicker(selectedImage: $viewModel.selectedImage, sourceType: .camera) }
        .onChange(of: viewModel.selectedImage) { _, image in if image != nil { viewModel.analyseSelectedImage() } }
        .alert("Pixi", isPresented: errorAlert, actions: { Button("OK", role: .cancel) {} }, message: { Text(viewModel.errorMessage ?? "") })
    }

    private var errorAlert: Binding<Bool> { Binding(get: { viewModel.errorMessage != nil }, set: { if !$0 { viewModel.errorMessage = nil } }) }
}

#Preview { EJChatView() }
