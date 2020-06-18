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
    var monsterNode: SCNNode?
    var position = SCNVector3()
    
    convenience init(level : Int) {
        self.init()
        self.level = level
    }
    
    override func viewDidAppear(_ animated: Bool) {
        #if !targetEnvironment(simulator)
        self.setupScene()
        #endif

        self.setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's AR session.
        sceneView?.session.pause()
    }
    
    func setupScene(){
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
        if #available(iOS 13.0, *) {
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
        sceneView?.session.run(configuration)
    }
    
    func setupUI(){
        let gameplayUI = GameplayUIView(frame: self.view.frame)
        gameplayUI.level = self.level
        gameplayUI.startAction = {
            self.killMonster()
            self.spawnMonster()
        }
        gameplayUI.stopAction = {
            self.navigationController?.popViewController(animated: true)
        }
        gameplayUI.nextLevelAction = {
            self.level += 1
            gameplayUI.level = self.level
        }
        
        self.view.addSubview(gameplayUI)
    }
    
    func spawnMonster(){
        let node = Boss().spawnBoss(type: 1)
        node.position = SCNVector3(x: 0, y: -0.5, z: -1)
        node.scale = SCNVector3(0.5, 0.5, 0.5)
        self.sceneView?.scene.rootNode.addChildNode(node)
    }
    
    func killMonster(){
        guard let node = self.monsterNode else {return}
        node.removeFromParentNode()
    }

    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        let meshNode : SCNNode
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
//
//        guard let meshGeometry = ARSCNPlaneGeometry(device: sceneView.device!)
//            else {
//                fatalError("Can't create plane geometry")
//        }
//        meshGeometry.update(from: planeAnchor.geometry)
//        meshNode = SCNNode(geometry: meshGeometry)
//        meshNode.opacity = 0.3
//        meshNode.name = "MeshNode"
//        self.position = meshNode.worldPosition
//
//        guard let material = meshNode.geometry?.firstMaterial
//            else { fatalError("ARSCNPlaneGeometry always has one material") }
//        material.diffuse.contents = UIColor.blue
//
//        node.addChildNode(meshNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
//
//        if let planeGeometry = node.childNode(withName: "MeshNode", recursively: false)!.geometry as? ARSCNPlaneGeometry {
////            planeGeometry.update(from: planeAnchor.geometry)
//        }
    }

    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
    }
}
