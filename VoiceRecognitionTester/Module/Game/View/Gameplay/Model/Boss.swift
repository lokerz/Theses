//
//  Boss.swift
//  VoiceRecognitionTester
//
//  Created by Ridwan Abdurrasyid on 05/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class Boss {
    static var shared = Boss()
    let HP              = 100
    let DAMAGE          = 10
    let DAMAGE_CRITICAL = 25
    let DISTANCE        = 3
    let SCALE           = 0.5
    
    var isDead = false
    var health = Int()
    var dead : (()->Void)?
    var revived : (()->Void)?
    var update : ((Float)->Void)?
    
    var node : SCNNode?
    
    var boss_model = "light_bulb_model"
    var idle_key = "light_bulb_idle"
    var attack_key = "light_bulb_atk"
    var attacked_key = "light_bulb_damage"
    var dead_key = "light_bulb_lose"
    
    init() {
        health = HP
    }
    
    func checkHP(){
        update?(Float(health)/Float(HP))
        isDead = health <= 0
        if isDead {
            self.killed() {
                self.dead?()
            }
        }
    }
    
    func spawned(completion : @escaping (()->Void)){
        guard let player = self.node?.animationPlayer(forKey: self.idle_key) else {return}
        player.play()
        player.animation.repeatCount = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + player.animation.duration) {
            player.stop()
            completion()

        }
    }
    
    func attack(completion : @escaping (()->Void)) {
        guard let player = self.node?.animationPlayer(forKey: self.attack_key) else {return}
        player.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + player.animation.duration - 1) {
            completion()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + player.animation.duration) {
            player.stop()
        }
    }
    
    func attacked(critical: Bool = false){
        health -= critical ? DAMAGE_CRITICAL : DAMAGE
        checkHP()
        if !isDead {
            guard let player = self.node?.animationPlayer(forKey: self.attacked_key) else {return}
            player.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + player.animation.duration) {
                player.stop()
            }
        }
    }
    
    func killed(completion : @escaping (()->Void)){
        guard let player = self.node?.animationPlayer(forKey: self.dead_key) else {return}
        player.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + player.animation.duration) {
            player.stop()
            completion()
        }
    }
    
    func revive(){
        health = HP
        checkHP()
        revived?()
    }
    
    func spawnBoss() -> SCNNode {
        guard let sceneURL = Bundle.main.url(forResource: boss_model, withExtension: "scn", subdirectory: "3DAssets.scnassets") else {return SCNNode()}
        guard let referenceNode = SCNReferenceNode(url: sceneURL) else {return SCNNode()}
        
        referenceNode.load()
        referenceNode.scale = SCNVector3(SCALE, SCALE, SCALE)
        referenceNode.randomColor()
        referenceNode.addAnimation(from: idle_key)
        referenceNode.addAnimation(from: attack_key)
        referenceNode.addAnimation(from: dead_key)
        referenceNode.addAnimation(from: attacked_key)
        self.node = referenceNode
        return referenceNode
    }
    
    func calculatePosition(frame: ARFrame) -> simd_float4x4{
        var translation = matrix_identity_float4x4
        translation.columns.3.z = Float(-DISTANCE)
        let rotation = matrix_float4x4(SCNMatrix4MakeRotation(Float.pi/2, 0, 0, 1))
        return simd_mul(frame.camera.transform, simd_mul(translation, rotation))
    }
    
    
    
}

