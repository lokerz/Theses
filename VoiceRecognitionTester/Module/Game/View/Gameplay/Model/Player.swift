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
    let IS_INVICIBLE = false
    let HP = 10
    
    var isDead = false
    var health = Int()
    var update : ((Int)->Void)?
    var dead : (()->Void)?
    
    init() {
        health = HP
    }
    
    func attacked(){
        guard !isDead else {return}
        health -= 1
        update?(health)
        checkHP()
    }
    
    func checkHP(){
        self.isDead = health <= 0 && !IS_INVICIBLE
        if isDead {
            dead?()
        }
    }
    
    func revive(){
        health = HP
        update?(health)
        checkHP()
    }
}
