//
//  VoiceAssistant.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 08/10/24.
//
import AVFoundation

class VoiceAssistant {
    private let synthesizer = AVSpeechSynthesizer()

    func speak(text: String) {
        // Configure the audio session for playback
        configureAudioSessionForPlayback()
        
        // If already speaking, stop before starting new speech
        if synthesizer.isSpeaking {
            stopSpeaking()
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate // Adjust the speed if necessary
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Or use "en-GB" for a British accent
        synthesizer.speak(utterance)
    }

    // Function to stop speaking
    func stopSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate) // Stop speech immediately
            
            // Reset audio session after stopping playback to allow recording again
            configureAudioSessionForRecording()
        }
    }

    // Audio session configuration for playback (speaking)
    private func configureAudioSessionForPlayback() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session for playback: \(error.localizedDescription)")
        }
    }

    // Audio session configuration for recording (speech recognition)
   func configureAudioSessionForRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to configure audio session for recording: \(error.localizedDescription)")
        }
    }
}
