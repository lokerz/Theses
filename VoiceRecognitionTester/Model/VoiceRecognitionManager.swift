//
//  VoiceRecognitionManager.swift
//  VoiceRecognitionTester
//
//  Created by Ridwan Abdurrasyid on 03/03/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import Foundation
import Speech
import AVKit

protocol VoiceRecognitionDelegate {
    func updateText(text : String)
}
class VoiceRecognitionManager {
    static var instance = VoiceRecognitionManager()
    let language = "zh-CN"
    
    //    speech recognizer variable
    let audioEngine = AVAudioEngine()
    var speechRecognizer = SFSpeechRecognizer()
    var request : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask : SFSpeechRecognitionTask?
    var timer = Timer()
    var delegate : VoiceRecognitionDelegate?
    //
    
    
    init() {
        setLocale(language: language)
    }
    
    func setLocale(language : String){
        let locale = Locale(identifier: language)
        guard let speechRecognizer = SFSpeechRecognizer(locale: locale) else {return}
        self.speechRecognizer = speechRecognizer
    }
    
    func supportedLocale(){
        print(SFSpeechRecognizer.supportedLocales())
        print(speechRecognizer?.locale)
    }
    
    func record(){
        self.request = SFSpeechAudioBufferRecognitionRequest()
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)
        
        audioEngine.reset()
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print("error")
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request!, resultHandler: { result, error in
            if result != nil {
                if let result = result {
                    let bestString = result.bestTranscription.formattedString
                    self.delegate?.updateText(text : bestString)
                } else if let error = error {
                    print(error)
                }
            }
        })
    }
    
    func stop(){
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionTask?.cancel()
        request?.endAudio()
        
        recognitionTask = nil
        request = nil

    }
    
}
