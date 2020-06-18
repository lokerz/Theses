//
//  Hint.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 17/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit

class HintManager {
    static var shared = HintManager()
    let COUNT = 10
    var count = 0
    
    var update : ((Int)->Void)?
    var hint_method  : (()->Void)?
    
    func hint()  {
        count -= 1
        hint_method?()
    }
    
    func add() {
        count += 1
        update?(count)
    }
    
    func check(){
        update?(count)
    }
    
    func reset(){
        count = COUNT
        update?(count)
    }
}
