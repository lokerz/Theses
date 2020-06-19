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
    
    override func setupScene(multiplayer: Bool = false){
        super.setupScene(multiplayer: true)
            self.spawnBoss()
            self.multipeerSession = MultipeerSession(receivedDataHandler: self.receivedData)
        
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
    
    override func spawnBoss() {
        super.spawnBoss()
        if self.isCreator {
            self.shareWorld()
        }
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: self.bossAnchor, requiringSecureCoding: true)
            else { fatalError("can't encode anchor") }
        self.multipeerSession?.sendToAllPeers(data)
        
    }
    
    // MARK: - ARSCNViewDelegate
    
    //    override func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    //        if let name = anchor.name, name.hasPrefix("Boss") {
    //            node.addChildNode(Boss().spawnBoss(type: 1))
    //        }
    //    }
    
    
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

