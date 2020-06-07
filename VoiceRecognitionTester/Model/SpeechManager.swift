//
//  SpeechManager.swift
//  VoiceRecognitionTester
//
//  Created by Ridwan Abdurrasyid on 07/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import Foundation
import AVFoundation

class SpeechManager: NSObject, AVSpeechSynthesizerDelegate {
    static var shared = SpeechManager()
    let synth = AVSpeechSynthesizer()
    var done_method : (()->Void)?
    
    override init() {
        super.init()
        synth.delegate = self
    }
    
    func speak(text: String) {
        setSpeaker(true)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: VoiceRecognitionManager.instance.language)
        utterance.rate = 0.3
        synth.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        setSpeaker(false)
        done_method?()
    }
    
    func setSpeaker(_ state : Bool){
        let audioSession = AVAudioSession.sharedInstance()
        let category : AVAudioSession.Category = state ? .playback : .record
        do {
            try audioSession.setCategory(category)
//            try audioSession.setActive(!state , options: .notifyOthersOnDeactivation)
        } catch (let error){
            print("audiosession error", error)
        }
    }
    
}
