//
//  GameManager.swift
//  VoiceRecognitionTester
//
//  Created by Ridwan Abdurrasyid on 05/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import Foundation

class GameManager {
    static var shared = GameManager()
    
    var win: (()->Void)?
    var lose: (()->Void)?
    var start: (()->Void)?
    var reset: (()->Void)?
    var pause: (()->Void)?
    var resume: (()->Void)?
    var stop: (()->Void)?
    var game_over_win: (()->Void)?
    var game_over_lose: (()->Void)?

    
    func gameOver(win : Bool){
        _ = win ? game_over_win?() : game_over_lose?()
    }
}
