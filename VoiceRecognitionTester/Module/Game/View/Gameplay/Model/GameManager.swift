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
    
    var correct: (()->Void)?
    var wrong: (()->Void)?
    var start: (()->Void)?
    var reset: (()->Void)?
    var pause: (()->Void)?
    var resume: (()->Void)?
    var stop: (()->Void)?
    var win: (()->Void)?
    var lose: (()->Void)?

    
    func gameOver(state : Bool){
        _ = state ? win?() : lose?()
    }
}
