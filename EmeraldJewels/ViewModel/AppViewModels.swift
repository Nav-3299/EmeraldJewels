import AVFoundation
import FirebaseAuth
import SwiftUI

protocol AuthenticationProviding {
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signOut() throws
    var currentUserEmail: String? { get }
}

struct FirebaseAuthenticationService: AuthenticationProviding {
    var currentUserEmail: String? { Auth.auth().currentUser?.email }

    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            completion(error.map(Result.failure) ?? .success(()))
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            completion(error.map(Result.failure) ?? .success(()))
        }
    }

    func signOut() throws { try Auth.auth().signOut() }
}

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    @Published private(set) var isAuthenticated = false

    private let service: any AuthenticationProviding

    init(service: any AuthenticationProviding = FirebaseAuthenticationService()) { self.service = service }

    func signIn() { authenticate(using: service.signIn) }
    func signUp() { authenticate(using: service.signUp) }

    private func authenticate(using action: @escaping (String, String, @escaping (Result<Void, Error>) -> Void) -> Void) {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !password.isEmpty else {
            errorMessage = "Enter both an email address and password."
            return
        }
        isLoading = true
        errorMessage = nil
        action(email, password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success: self?.isAuthenticated = true
                case .failure(let error): self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published private(set) var userEmail = "No Email"
    @Published var errorMessage: String?

    private let service: any AuthenticationProviding

    init(service: any AuthenticationProviding = FirebaseAuthenticationService()) { self.service = service }

    func loadProfile() { userEmail = service.currentUserEmail ?? "No Email" }

    func logout() -> Bool {
        do {
            try service.signOut()
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}

@MainActor
final class CheckoutViewModel: ObservableObject {
    @Published var name = ""
    @Published var address = ""
    @Published private(set) var isOrderPlaced = false
    @Published var validationMessage: String?

    func continueToConfirmation() -> Bool {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            validationMessage = "Please enter both your name and delivery address."
            return false
        }
        validationMessage = nil
        return true
    }

    func confirmOrder() { isOrderPlaced = true }
}

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var isImagePickerPresented = false
    @Published var isCameraPresented = false
    @Published var isLoading = false
    @Published var outfitType: String?
    @Published var responseText = ""
    @Published var errorMessage: String?
    @Published var messageText = ""
    @Published private(set) var isSending = false

    let speechRecognizer: SpeechRecognizer
    private let recommendationService: any AIRecommendationServing

    init(speechRecognizer: SpeechRecognizer = SpeechRecognizer(), recommendationService: any AIRecommendationServing = OpenAIService()) {
        self.speechRecognizer = speechRecognizer
        self.recommendationService = recommendationService
        speechRecognizer.onTranscriptChanged = { [weak self] text in
            DispatchQueue.main.async { self?.messageText = text }
        }
        speechRecognizer.onRecordingFinished = { [weak self] text in
            DispatchQueue.main.async { self?.sendMessage(text) }
        }
    }

    func analyseSelectedImage() {
        guard let selectedImage else { return }
        isLoading = true
        errorMessage = nil
        classifyOutfit(image: selectedImage) { [weak self] outfit in
            DispatchQueue.main.async {
                guard let self else { return }
                self.outfitType = outfit ?? "Unknown"
                self.isLoading = false
                guard let outfit else {
                    self.errorMessage = "We could not identify the outfit."
                    return
                }
                self.sendMessage("I am wearing a \(outfit) outfit. Please recommend matching jewellery.")
            }
        }
    }

    func sendTypedMessage() {
        sendMessage(messageText)
    }

    func sendMessage(_ message: String) {
        let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else {
            errorMessage = "Write or record a message before sending it."
            return
        }
        isSending = true
        errorMessage = nil
        recommendationService.sendMessage(trimmedMessage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isSending = false
                switch result {
                case .success(let response):
                    self?.responseText = response
                    self?.speechRecognizer.speak(response)
                case .failure(let error): self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func clearConversation() {
        selectedImage = nil
        outfitType = nil
        responseText = ""
        messageText = ""
        isSending = false
        errorMessage = nil
        speechRecognizer.clear()
        speechRecognizer.stopSpeaking()
    }
}
