//
//  GameplayViewController.swift
//  VoiceRecognitionTester
//
//  Created by Ridwan Abdurrasyid on 12/04/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit
import ARKit

class GameplayViewController: UIViewController {
    
    var level = 0
    var sceneView : ARSCNView?
    var position = SCNVector3()
    
    convenience init(level : Int) {
        self.init()
        self.level = level
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        #if targetEnvironment(simulator)
          // your simulator code
        #else
            self.setupScene()
        #endif

        self.setupUI()
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
        gameplayUI.startAction = {
            self.spawnMonster()
        }
        self.view.addSubview(gameplayUI)
    }
    
    func spawnMonster(){
        guard let monster = SCNScene(named: "3DAssets.scnassets/Boss.scn"),
            let monsterNode = monster.rootNode.childNode(withName: "Boss", recursively: false)
            else { return }
        
        monsterNode.position = SCNVector3(x: 0, y: -0.5, z: -1)
        monsterNode.scale = SCNVector3(0.5, 0.5, 0.5)
        self.sceneView?.scene.rootNode.addChildNode(monsterNode)
    }
    
}

extension GameplayViewController : ARSCNViewDelegate {
    
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
}

extension GameplayViewController : ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
    }
}
