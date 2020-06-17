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
    var count = 10
    
    var update : ((Int)->Void)?
    var hint_method  : (()->Void)?
    
    func hint()  {
        count -= 1
        hint_method?()
    }
    
    func check(){
        update?(count)
    }
    
    func reset(){
        count = 10
        update?(count)
    }
}
