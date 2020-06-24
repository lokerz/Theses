//
//  NonARGameplayViewController.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 24/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//
//
//  GameplayViewController.swift
//  VoiceRecognitionTester
//
//  Created by Ridwan Abdurrasyid on 12/04/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit
import SceneKit

class NonARGameplayViewController : GameplayViewController {
    
    var _sceneView : SCNView?
    var bossNode : SCNNode?
    
    convenience init(level : Int) {
        self.init()
        self.level = level
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupScene()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupScene(){
        self._sceneView = SCNView(frame: self.view.frame)
        guard let sceneView = self._sceneView else {return}
        let scene = SCNScene(named: "3DAssets.scnassets/World.scn")
        sceneView.scene = scene
        sceneView.delegate = self
        sceneView.allowsCameraControl = true

        self.view.addSubview(sceneView)
        self.respawnBoss()
    }
    
    override func respawnBoss(){
        guard !bossSpawned else {return}
        self.bossNode = Boss.shared.spawnBoss()
        guard let boss = self.bossNode else {return}
        DispatchQueue.main.async {
            self._sceneView?.scene?.rootNode.addChildNode(boss)
            Boss.shared.level = self.level
            Boss.shared.spawned {
                self.setupUI()
                self.bossSpawned = true
            }
        }
    }
    
    override func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if isKillBoss {
            self.bossNode?.removeFromParentNode()
            isKillBoss = false
            bossSpawned = false
        }
    }
    
}
