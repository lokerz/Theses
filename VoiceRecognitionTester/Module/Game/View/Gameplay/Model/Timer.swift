//
//  Timer.swift
//  VoiceRecognitionTester
//
//  Created by Ridwan Abdurrasyid on 05/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit

class TimerManager {
    static var shared = TimerManager()
    let TIME_OUT        = 8.0
    let TIME_OUT_LONG   = 20.0
    
    var set_method : ((Float) -> Void)?
    var reset_method : (()->Void)?
    var done_method : (()->Void)?
    
    var timeRemaining = Double()
    var timer = Timer()
    var isCritical = false
    
    func start(critical: Bool = false){
        self.reset()
        self.isCritical = critical
        self.timeRemaining = isCritical ? TIME_OUT_LONG : TIME_OUT
        print(#function, self.timeRemaining)
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(runningTimer), userInfo: nil, repeats: true)
    }
    
    func stop(){
        self.timer.invalidate()
    }
    
    func reset(){
        self.timer.invalidate()
        reset_method?()
    }
    
    func resume(){
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(runningTimer), userInfo: nil, repeats: true)
    }
    
    @objc func runningTimer(){
        self.timeRemaining -= 0.01
        set_method?(Float(self.timeRemaining / (self.isCritical ? TIME_OUT_LONG : TIME_OUT)))
        if timeRemaining <= 0 {
            done_method?()
        }
    }
    
    
}
