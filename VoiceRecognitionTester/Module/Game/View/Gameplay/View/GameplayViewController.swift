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
    var gameUI : GameplayUIView?
    var lastHitResult: ARHitTestResult?
    
    var bossSpawned = false
    var isKillBoss  = false
        
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
        sceneView?.addGestureRecognizer(UITapGestureRecognizer(target: self , action: #selector(spawnBoss(sender:))))
    }
    
    func setupUI(){
        self.gameUI = GameplayUIView(frame: self.view.frame)
        guard let gameUI = gameUI else {return}
        gameUI.level = self.level
        gameUI.stopAction = {
            self.navigationController?.popViewController(animated: true)
        }
        gameUI.nextLevelAction = {
            self.level += 1
            gameUI.level = self.level
            self.respawnBoss()
        }
        gameUI.killBossAction = {
            self.killBoss()
        }
        
        self.view.addSubview(gameUI)
    }
    
    
    @objc func spawnBoss(sender: UITapGestureRecognizer){
        guard !bossSpawned else {return}
        guard let hitTestResult = sceneView?
            .hitTest(sender.location(in: sceneView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
            .first
            else { return }
        self.lastHitResult = hitTestResult
        self.respawnBoss()
    }
    
    func respawnBoss(){
        guard !bossSpawned else {return}
        guard let lastHit = self.lastHitResult else {return}
        let anchor = ARAnchor(name: "Boss", transform: lastHit.worldTransform)
        self.bossAnchor = anchor
        sceneView?.session.add(anchor: anchor)
        bossSpawned = true
    }
    
    func killBoss(){
        self.isKillBoss = true
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if isKillBoss {
            guard let anchor = bossAnchor else {return}
            sceneView?.session.remove(anchor: anchor)
            isKillBoss = false
            bossSpawned = false
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let name = anchor.name, name.hasPrefix("Boss") {
            node.addChildNode(Boss.shared.spawnBoss())
            Boss.shared.level = self.level
            Boss.shared.spawned {
                DispatchQueue.main.async {
                    self.setupUI()
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let name = anchor.name, name.hasPrefix("Boss") {
            node.removeFromParentNode()
        }
    }
    
    
}
