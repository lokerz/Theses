//
//  GameplayViewController.swift
//  VoiceRecognitionTester
//
//  Created by Ridwan Abdurrasyid on 12/04/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit
import ARKit

class GameplayViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    var level = 0
    var sceneView : ARSCNView?
    var bossAnchor : ARAnchor?
    
    var bossSpawned = false
    
    convenience init(level : Int) {
        self.init()
        self.level = level
    }
    
    override func viewDidAppear(_ animated: Bool) {
        #if !targetEnvironment(simulator)
        self.setupScene()
        #endif
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's AR session.
        sceneView?.session.pause()
    }
    
    func setupScene(multiplayer : Bool = false){
        self.sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(self.sceneView!)
        
        let scene = SCNScene()
        sceneView?.scene = scene
        sceneView?.delegate = self
        sceneView?.session.delegate = self
        sceneView?.automaticallyUpdatesLighting = true
        sceneView?.autoenablesDefaultLighting = true
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        configuration.isCollaborationEnabled = multiplayer
        configuration.frameSemantics.insert(.personSegmentationWithDepth)
        
        sceneView?.session.run(configuration)
    }
    
    func setupUI(){
        let gameplayUI = GameplayUIView(frame: self.view.frame)
        gameplayUI.level = self.level
        gameplayUI.startAction = {

        }
        gameplayUI.stopAction = {
            self.navigationController?.popViewController(animated: true)
        }
        gameplayUI.nextLevelAction = {
            self.level += 1
            gameplayUI.level = self.level
            self.bossSpawned = false
        }
        gameplayUI.killBossAction = {
            self.killBoss()
        }
        
        self.view.addSubview(gameplayUI)
    }
    
    func spawnBoss(){
        guard let currentFrame = sceneView?.session.currentFrame else {return}

        let anchor = ARAnchor(name: "Boss", transform: Boss.shared.calculatePosition(frame: currentFrame))
        self.bossAnchor = anchor
        sceneView?.session.add(anchor: anchor)
    }
    
    func killBoss(){
        guard let anchor = bossAnchor else {return}
        sceneView?.session.remove(anchor: anchor)
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if !bossSpawned {
            spawnBoss()
            bossSpawned = true
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let name = anchor.name, name.hasPrefix("Boss") {
            node.addChildNode(Boss.shared.spawnBoss())
            Boss.shared.spawned {
                self.setupUI()
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let name = anchor.name, name.hasPrefix("Boss") {
            node.removeFromParentNode()
        }
    }
    
    
}
