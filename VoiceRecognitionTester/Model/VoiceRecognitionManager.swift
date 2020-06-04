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
    
    //    speech recognizer variable
    let audioEngine = AVAudioEngine()
    var speechRecognizer = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask : SFSpeechRecognitionTask?
    var timer = Timer()
    var delegate : VoiceRecognitionDelegate?
    //
    func setLocale(language : String){
        let locale = Locale(identifier: language)
        guard let speechRecognizer = SFSpeechRecognizer(locale: locale) else {return}
        self.speechRecognizer = speechRecognizer
    }
    
    func supportedLocale(){
        print(SFSpeechRecognizer.supportedLocales())
        print(speechRecognizer?.locale)
    }
    
    func recordAndRecognizeSpeech(){
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print("error")
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
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
        recognitionTask?.cancel()
        
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
}
