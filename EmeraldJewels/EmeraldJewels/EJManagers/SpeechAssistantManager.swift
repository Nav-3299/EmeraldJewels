//
//  SpeechAssistant.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 08/10/24.
//

import SwiftUI
import Speech
import AVFoundation

class SpeechRecognizer: NSObject, SFSpeechRecognizerDelegate, ObservableObject {
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private let voiceAssistant = VoiceAssistant()
    private let audioSession = AVAudioSession.sharedInstance() // Keep audioSession as a class variable

    @Published var transcribedText = ""
    @Published var openAIResponseText: String = ""
    
    func startRecording() {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            print("Speech recognizer is not available.")
            return
        }
        
        // Reset audio engine if it's already running
        if audioEngine.isRunning {
            stopRecording()
        }
        transcribedText = ""
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        voiceAssistant.configureAudioSessionForRecording()
        // Set up audio session
        do {
            // Use .playAndRecord category to avoid audio conflicts and allow volume buttons to work
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .defaultToSpeaker])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
            return
        }
        
        // Start audio input
        let inputNode = audioEngine.inputNode
        inputNode.removeTap(onBus: 0) // Remove existing tap if present

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
        } catch {
            print("Audio engine couldn't start: \(error.localizedDescription)")
            return
        }

        // Perform speech recognition
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest!) { result, error in
            if let result = result {
                self.transcribedText = result.bestTranscription.formattedString
            }
            if let error = error {
                print("Speech recognition error: \(error.localizedDescription)")
            }
        }
    }

    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0) // Remove the tap to avoid conflicts
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        
        // Deactivate the audio session once recording is finished
        do {
            try audioSession.setActive(false)
        } catch {
            print("Failed to deactivate audio session: \(error)")
        }

        // After stopping the recording, send the text to OpenAI
        if !transcribedText.isEmpty {
            sendTextToOpenAI(message: transcribedText)
        }
    }
    
    func sendTextToOpenAI(message: String) {
        OpenAIService().sendMessageToOpenAI(message: message) { [weak self] response in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.openAIResponseText = response ?? "No result found"
                self?.voiceAssistant.speak(text: response ?? "Oops! No response found")
            }
        }
    }
    
    func stopSpeaking(){
        self.voiceAssistant.stopSpeaking()
    }
}
