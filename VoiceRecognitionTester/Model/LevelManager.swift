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
    var TOTAL_LEVEL = 8
    var lock_status = [Bool]()
    var key = "SoundBooLevel"
    let defaults = UserDefaults.standard
    
    func loadDefault(){
        self.lock_status = defaults.array(forKey: key) as? [Bool] ?? [Bool]()
        self.checkLevel()
        
        if self.lock_status.isEmpty {
            self.lock_status = Array(repeating: false, count: TOTAL_LEVEL)
            self.lock_status[0] = true
            self.saveDefault()
        }
    }
    
    func checkLevel(){
        self.TOTAL_LEVEL = WordManager.instance.sentences.last?.Level ?? 8
        if lock_status.count > self.TOTAL_LEVEL {
            self.lock_status.removeLast(lock_status.count - TOTAL_LEVEL)
        } else {
            self.lock_status.append(contentsOf: Array(repeating: false, count: TOTAL_LEVEL - lock_status.count))
        }
        self.saveDefault()
    }
    
    func saveDefault(){
        defaults.set(self.lock_status, forKey: key)
    }
    
    func unlockLevel(level: Int){
        guard level < TOTAL_LEVEL else {return}
        self.lock_status[level - 1] = true
        self.saveDefault()
    }
}
