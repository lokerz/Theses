//
//  Boss.swift
//  VoiceRecognitionTester
//
//  Created by Ridwan Abdurrasyid on 05/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit
import SceneKit

class Boss {
    static var shared = Boss()
    let HP              = 100
    let DAMAGE          = 10
    let DAMAGE_CRITICAL = 25
    
    var isDead = false
    var health = Int()
    var dead : (()->Void)?
    var revived : (()->Void)?
    var update : ((Float)->Void)?
    
    init() {
        health = HP
    }
    
    func spawnBoss(type: Int) -> SCNNode {
        let sceneURL = Bundle.main.url(forResource: "Boss", withExtension: "scn", subdirectory: "3DAssets.scnassets")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        return referenceNode
    }
    
    
    func attacked(critical: Bool = false){
        health -= critical ? DAMAGE_CRITICAL : DAMAGE
        checkHP()
    }
    
    func checkHP(){
        update?(Float(health)/Float(HP))
        isDead = health <= 0
        if isDead {
            dead?()
        }
    }
    
    func revive(){
        health = HP
        checkHP()
        revived?()
    }
}
