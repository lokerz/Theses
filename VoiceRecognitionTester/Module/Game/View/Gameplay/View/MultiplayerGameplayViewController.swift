//
//  MultiplayerUIViewController.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 18/06/20.
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
import ARKit
import MultipeerConnectivity

class MultiplayerGameplayViewController: GameplayViewController {
    
    var multipeerSession: MultipeerSession?
    var mapProvider: MCPeerID?
    
    var isCreator = false

    convenience init(level : Int, create: Bool) {
        self.init(nibName: "GameplayViewController", bundle: nil)
        self.level = level
        self.isCreator = create
    }
    
    override func setupScene(){
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
        configuration.isCollaborationEnabled = true
        if #available(iOS 13.0, *) {
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
        sceneView?.session.run(configuration)
        
        self.multipeerSession = MultipeerSession(receivedDataHandler: receivedData)
    }
    
    override func setupUI(){
        let gameplayUI = GameplayUIView(frame: self.view.frame)
        gameplayUI.level = self.level
        gameplayUI.startAction = {
            if self.isCreator {self.shareWorld()}
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
    
    func shareWorld(){
        sceneView?.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap
                else { print("Error: \(error!.localizedDescription)"); return }
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                else { fatalError("can't encode map") }
            self.multipeerSession?.sendToAllPeers(data)
        }
    }
    
    override func spawnMonster() {
        guard let currentFrame = sceneView?.session.currentFrame else {return}
        
        // Create a transform with a translation of 30 cm in front of the camera
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1
        let rotation = matrix_float4x4(SCNMatrix4MakeRotation(Float.pi/2, 0, 0, 1))
        let transform = simd_mul(currentFrame.camera.transform, simd_mul(translation, rotation))

        // Add a new anchor to the session
        let anchor = ARAnchor(name: "Boss", transform: transform)
        sceneView?.session.add(anchor: anchor)
        
        // Send the anchor info to peers, so they can place the same content.
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: anchor, requiringSecureCoding: true)
            else { fatalError("can't encode anchor") }
        self.multipeerSession?.sendToAllPeers(data)
        
    }
    
    // MARK: - ARSCNViewDelegate
    
    override func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let name = anchor.name, name.hasPrefix("Boss") {
            node.addChildNode(Boss().spawnBoss(type: 1))
        }
    }
    
    
    // MARK: - ARSessionObserver
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        // Remove optional error messages.
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            // Present an alert informing about the error that has occurred.
            let alertController = UIAlertController(title: "The AR session failed.", message: errorMessage, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
                self.resetTracking()
            }
            alertController.addAction(restartAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Multiuser shared session
    
    
    /// - Tag: ReceiveData
    func receivedData(_ data: Data, from peer: MCPeerID) {
        
        do {
            if let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) {
                // Run the session with the received world map.
                let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = .horizontal
                configuration.initialWorldMap = worldMap
                if #available(iOS 13.0, *) {
                    configuration.frameSemantics.insert(.personSegmentationWithDepth)
                }
                sceneView?.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
                
                // Remember who provided the map for showing UI feedback.
                mapProvider = peer
            }
            else
                if let anchor = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARAnchor.self, from: data) {
                    // Add anchor to the session, ARSCNView delegate adds visible content.
                    sceneView?.session.add(anchor: anchor)
                }
                else {
                    print("unknown data recieved from \(peer)")
            }
        } catch {
            print("can't decode data recieved from \(peer)")
        }
    }
    
    
    func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView?.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
}

