//
//  LevelManager.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 18/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import Foundation

class LevelManager {
    static var shared = LevelManager()
    let TOTAL_LEVEL = 8
    var lock_status = [Bool]()
    var key = "SoundBooLevel"
    
    func loadDefault(){
        let defaults = UserDefaults.standard
        self.lock_status = defaults.array(forKey: key) as? [Bool] ?? [Bool]()
        
        if self.lock_status.isEmpty {
            self.lock_status = Array(repeating: false, count: TOTAL_LEVEL)
            self.lock_status[0] = true
            self.saveDefault()
        }
    }
    
    func saveDefault(){
        let defaults = UserDefaults.standard
        defaults.set(self.lock_status, forKey: key)
    }
    
    func unlockLevel(level: Int){
        guard level < TOTAL_LEVEL else {return}
        self.lock_status[level - 1] = true
        self.saveDefault()
    }
}
