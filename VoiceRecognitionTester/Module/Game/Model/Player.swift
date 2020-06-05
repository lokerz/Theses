//
//  Player.swift
//  VoiceRecognitionTester
//
//  Created by Ridwan Abdurrasyid on 05/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit

class Player {
    static var shared = Player()
    let HP = 10
    
    var health = Int()
    var update : ((Int)->Void)?
    var dead : (()->Void)?
    
    init() {
        health = HP
    }
    
    func attacked(){
        health -= 1
        update?(health)
        checkHP()
    }
    
    func checkHP(){
        if health <= 0 {
            dead?()
        }
    }
    
    func revive(){
        health = HP
        update?(health)
    }
}
