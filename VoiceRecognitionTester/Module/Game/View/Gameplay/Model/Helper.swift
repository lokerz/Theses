//
//  File.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 19/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import Foundation
import SceneKit

extension SCNNode {
    func randomColor() {
        for node in self.childNodes {
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.random
        }
    }
    
    func addAnimation(from node: String){
        guard let url = Bundle.main.url(forResource: node, withExtension: "dae", subdirectory: "3DAssets.scnassets/Animation") else {return}
        guard let source = SCNSceneSource(url: url, options: nil) else {return}
        guard let caAnimation = source.entryWithIdentifier(node + "-1", withClass: CAAnimation.self) else {return}
        let animation = SCNAnimation(caAnimation: caAnimation)
        let player = SCNAnimationPlayer(animation: animation)
        self.addAnimationPlayer(player, forKey: node)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
