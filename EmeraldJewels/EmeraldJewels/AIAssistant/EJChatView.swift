//
//  EJChatView.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 09/10/24.
//

import SwiftUI
import AVFoundation

struct EJChatView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented = false
    @State private var isLoading = false
    @State private var recommendedJewellery: [String] = []
    @State private var outfitType: String? = nil
    @State private var isPressing = false
    @State private var microphoneSize: CGFloat = 50 // Default size for the microphone image
    @State private var isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
    @State private var isCameraPresented = false
    // Add AVSpeechSynthesizer to speak the response
    let speechSynthesizer = AVSpeechSynthesizer()
    // Add audio session for managing the microphone and playback
    let audioSession = AVAudioSession.sharedInstance()

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    EJUtility.shared.getAIAvatar()
                    
                    if isLoading {
                        ProgressView("Analyzing...")
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 100)
                    } else if let outfit = outfitType {
                        // Update if needed
                    }
                    
                    ScrollView {
                        if !speechRecognizer.transcribedText.isEmpty {
                            Text("Transcribed Text:")
                                .foregroundStyle(.white)
                            Text(speechRecognizer.transcribedText)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .foregroundStyle(.white)
                        }
                        
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .frame(width: 300, height: 300)
                                .onAppear(perform: {
                                    analyzeOutfit(image: image)
                                })
                        }
                        
                        if !speechRecognizer.openAIResponseText.isEmpty {
                            Text("AI Response:")
                                .foregroundStyle(.white)
                            Text(speechRecognizer.openAIResponseText)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .foregroundStyle(.white)
                                .onAppear(perform: {
                                    speakResponse(speechRecognizer.openAIResponseText)
                                })
                        }
                    }
                    Spacer()
                    HStack(spacing : 50) {
                        SelectImageToUpload
                        StopSpeaking
                        recorderView
                        CameraButton
                    }
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .padding()
                }
                .background(EJUtility.shared.getTheme())
            }
        }
        .onAppear {
            configureAudioSession()
        }
    }
    
    // Configure the audio session for recording and playback
    func configureAudioSession() {
        do {
            try audioSession.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
    
    // Speak the response from OpenAI using AVSpeechSynthesizer
    func speakResponse(_ text: String) {
        // Ensure the recording is stopped before speech synthesis
        speechRecognizer.stopRecording()

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            //self.speechSynthesizer.speak(utterance)
        }
    }
}

#Preview {
    EJChatView()
}

extension EJChatView {
    
    func analyzeOutfit(image: UIImage) {
        isLoading.toggle()
        classifyOutfit(image: image) { result in
            DispatchQueue.main.async {
                if let outfit = result {
                    outfitType = outfit
                    speechRecognizer.sendTextToOpenAI(message: "I am wearing a \(outfit) outfit. Please recommend matching Jewellery with this outfit.")
                } else {
                    outfitType = "Unknown"
                    recommendedJewellery = []
                }
                isLoading = false
            }
        }
    }
    
    func stopRecordingAndDeactivateAudioSession() {
        speechRecognizer.stopRecording()

        do {
            // Deactivate the audio session
            try audioSession.setActive(false)
        } catch {
            print("Failed to deactivate audio session: \(error)")
        }
    }
    
    private var recorderView: some View {
        Button {
            // Recording logic handled by SpeechRecognizer
            selectedImage = nil
        } label: {
            Image(.microphone)
                .resizable()
                .clipShape(Circle())
                .frame(width: microphoneSize, height: microphoneSize)
                .scaleEffect(isPressing ? 3.0 : 1.0) // Animate size
                .animation(.easeInOut(duration: 0.3), value: isPressing)
        }
        .onLongPressGesture(minimumDuration: 0.1, pressing: { isPressing in
            self.isPressing = isPressing
            if isPressing {
                // Start recording
                speechRecognizer.startRecording()
            } else {
                // Stop recording
                stopRecordingAndDeactivateAudioSession()
            }
        }, perform: {
            // Code for completion if needed
        })
    }
    
    private var SelectImageToUpload: some View {
        Button(action: {
            selectedImage = nil
            speechRecognizer.transcribedText = ""
            isImagePickerPresented.toggle()
        }, label: {
            Image(systemName: "person.2.crop.square.stack.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(.white)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        })
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
        }
    }
    
    private var CameraButton: some View {
        Button(action: {
            selectedImage = nil
            speechRecognizer.transcribedText = ""
            isCameraPresented.toggle()
        }) {
            Image(systemName: "camera.aperture")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(.white)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .sheet(isPresented: $isCameraPresented) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
        }
        .disabled(!isCameraAvailable)
    }
    
    private var StopSpeaking : some View{
        // Button to stop the AI from speaking
        Button(action: {
            selectedImage = nil
            speechRecognizer.openAIResponseText = ""
            speechRecognizer.transcribedText = ""
            speechRecognizer.stopSpeaking()
        }) {
            Image(systemName: "stop.circle.fill")
                .foregroundColor(.red)
                .padding()
                .background(Color.gray.opacity(0.2))
                .clipShape(Circle())
                
        }

    }
}
