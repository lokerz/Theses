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
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblConnection: UILabel!
    
    var level = 0
    var sceneView : ARSCNView?
    var coachingView : ARCoachingOverlayView?
    var bossAnchor : ARAnchor?
    var gameUI : GameplayUIView?
    var lastTransform: simd_float4x4?
    
    var bossSpawned = false
    var isKillBoss  = false
    
    convenience init(level : Int) {
        self.init()
        self.level = level
        Boss.shared.isMultiplayer = false
    }
    
    @IBAction func actionDismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.askCameraPermission()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's AR session.
        sceneView?.session.pause()
    }
    
    func askCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            self.setupScene()
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.setupScene()
                }
            }
            
        case .denied: // The user has previously denied access.
            return
            
        case .restricted: // The user can't grant access due to restrictions.
            return
            
        @unknown default :
            return
        }
    }
    
    func setupScene(multiplayer : Bool = false){
        self.sceneView = ARSCNView(frame: self.view.frame)
        guard let sceneView = sceneView else {return}
        self.view.addSubview(sceneView)
        
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        configuration.isCollaborationEnabled = multiplayer
        
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        self.coachingView = ARCoachingOverlayView(frame: self.view.frame)
        guard let coachingView = self.coachingView else { return }
        coachingView.session = sceneView.session
        coachingView.activatesAutomatically = true
        coachingView.goal = .horizontalPlane
        self.view.addSubview(coachingView)
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
            self.gameUI?.removeFromSuperview()
        }
        gameUI.killBossAction = {
            self.killBoss()
        }
        
        self.view.addSubview(gameUI)
    }
    
    
    func spawnBoss(transform: simd_float4x4){
        guard !bossSpawned else {return}
        self.lastTransform = transform
        self.respawnBoss()
    }
    
    func respawnBoss(){
        guard !bossSpawned else {return}
        guard let lastTransform = self.lastTransform else {return}
        let anchor = ARAnchor(name: "Boss", transform: lastTransform)
        self.bossAnchor = anchor
        DispatchQueue.main.async {
            self.sceneView?.session.add(anchor: anchor)
            self.bossSpawned = true
            self.coachingView?.removeFromSuperview()
        }
    }
    
    func killBoss(){
        self.isKillBoss = true
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if !bossSpawned {
            if let planeAnchor = anchor as? ARPlaneAnchor,
                let planeNode = node.childNodes.first,
                let plane = planeNode.geometry as? SCNPlane {
                plane.width = CGFloat(planeAnchor.extent.x)
                plane.height = CGFloat(planeAnchor.extent.z)
                planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
            }
        }
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
        if let planeAnchor = anchor as? ARPlaneAnchor, !bossSpawned{
            self.spawnBoss(transform: planeAnchor.transform)
        }
        
        if let name = anchor.name, name.hasPrefix("Boss") {
            DispatchQueue.main.async {
                node.addChildNode(Boss.shared.spawnBoss())
                Boss.shared.level = self.level
                Boss.shared.spawned {
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
