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
    var count = 0
    
    var update : ((Int)->Void)?
    var hint_method  : (()->Void)?
    
    var key = "SoundBooHint"
    let defaults = UserDefaults.standard
    
    func loadUserDefault(){
        if defaults.object(forKey: key) == nil {
            self.defaults.register(defaults: [key : 5])
        }
        self.count = defaults.integer(forKey: key)
    }
    
    func saveUserDefault(){
        defaults.set(self.count, forKey: key)
    }
    
    func hint()  {
        count -= 1
        hint_method?()
    }
    
    func add() {
        count += 1
        update?(count)
        saveUserDefault()
    }
    
    func check(){
        update?(count)
        saveUserDefault()
    }
    
}
