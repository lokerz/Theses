//
//  SoundManager.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 21/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit
import AVFoundation

class SoundManager : NSObject, AVAudioPlayerDelegate {
        
    static var shared = SoundManager()
    var player: AVAudioPlayer?

    func play(){
        do {
            player?.stop()
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            guard let url = Bundle.main.url(forResource: "Click 2", withExtension: "m4a") else {return}
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)
            guard let player = player else { return }
            player.delegate = self
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        SpeechManager.shared.setSpeaker(false)
        VoiceRecognitionManager.instance.stop()
    }
}

