//
//  Boss.swift
//  VoiceRecognitionTester
//
//  Created by Ridwan Abdurrasyid on 05/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit

class Boss {
    static var shared = Boss()
    let HP              = 100
    let DAMAGE          = 10
    let DAMAGE_CRITICAL = 25
    
    var health = Int()
    var dead : (()->Void)?
    var revived : (()->Void)?
    var update : ((Float)->Void)?
    
    init() {
        health = HP
    }
    
    func attacked(critical: Bool = false){
        health -= critical ? DAMAGE_CRITICAL : DAMAGE
        checkHP()
    }
    
    func checkHP(){
        update?(Float(health)/Float(HP))
        if health <= 0 {
            dead?()
        }
    }
    
    func revive(){
        health = HP
        checkHP()
        revived?()
    }
}
