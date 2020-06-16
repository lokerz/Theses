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
    
    var win_method: (()->Void)?
    var lose_method: (()->Void)?
    var start_method: (()->Void)?
    var reset_method: (()->Void)?

    func win(){
        win_method?()
    }
    
    func lose(){
        lose_method?()
    }
    
    func start(){
        start_method?()
    }
    
    func reset(){
        reset_method?()
    }
}
