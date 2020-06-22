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
    
    var multipeerSession: MultipeerSession!
    var isCreator = false
    var isConnected = false
    var multiGameUI: MultiplayerGameplayUIView?
    
    convenience init(level : Int, create: Bool) {
        self.init(nibName: "GameplayViewController", bundle: nil)
        self.level = level
        self.isCreator = create
        Boss.shared.isMultiplayer = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        multipeerSession.disconnect()
    }
    
    override func setupScene(multiplayer: Bool = false){
        super.setupScene(multiplayer: true)
        self.multipeerSession = MultipeerSession(receivedDataHandler: self.receivedData)
        self.multipeerSession.isCreator = isCreator
        self.multipeerSession.sendData = {
            self.connect()
        }
        
        self.btnBack.isHidden = false
        self.view.bringSubviewToFront(self.lblConnection)
        self.view.bringSubviewToFront(self.btnBack)
        if !isCreator {
            self.coachingView?.removeFromSuperview()
        }
    }
    
    override func setupUI(){
        self.btnBack.isHidden = true
        self.multiGameUI = MultiplayerGameplayUIView(frame: self.view.frame)
        guard let gameUI = multiGameUI else {return}
        gameUI.level = self.level
        gameUI.stopAction = {
            self.navigationController?.popViewController(animated: true)
        }
        gameUI.killBossAction = {
            self.killBoss()
        }
        gameUI.attackBossAction = { val in
            self.shareBossStatus(val : val)
        }
        gameUI.nextLevelAction = {
            self.navigationController?.popViewController(animated: true)
        }
        
        self.view.addSubview(gameUI)

    }
    
    override func spawnBoss(transform : simd_float4x4) {
        guard isCreator else {return}
        super.spawnBoss(transform: transform)
    }
    
    override func respawnBoss() {
        guard isCreator else {return}
        super.respawnBoss()
    }
    
    func prepareConnect(){
        guard !(multipeerSession.connectedPeers.isEmpty) else {return}
        guard isCreator && !isConnected else {return}
        self.isConnected = true
        self.setupUI()
        self.connect()
    }
    
    func connect(){
        self.shareLevel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.shareWorld()
        }
    }
    
    func shareWorld(){
        sceneView?.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap
                else { print("Error: \(error!.localizedDescription)"); return }
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                else { fatalError("can't encode map") }
            self.multipeerSession.sendToAllPeers(data)
        }
    }
    
    func shareLevel(){
        if isCreator {
            guard let data = String(self.level).data(using: .utf8) else {return}
            self.multipeerSession.sendToAllPeers(data)
        }
    }
    
    func shareBossStatus(val : Bool = false){
        if isCreator {
            guard let data = String(Boss.shared.health).data(using: .utf8) else {return}
            self.multipeerSession.sendToAllPeers(data)
        } else {
            guard let data = String(val).data(using: .utf8) else {return}
            self.multipeerSession.sendToAllPeers(data)
        }
    }
    
    func updateLabel(){
        var str = String()
        if isCreator && multipeerSession.connectedPeers.isEmpty {
            str = "Waiting for Players to join"
        } else if !isCreator && multipeerSession.connectedPeers.isEmpty {
            str = "Waiting for Hosts"
        } else {
            str = "Connected with : \(multipeerSession.connectedPeers.map({ $0.displayName }).joined(separator: ", "))"
        }
        self.lblConnection.text = str
    }
    
    override func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            self.spawnBoss(transform: planeAnchor.transform)
        }
        
        if let name = anchor.name, name.hasPrefix("Boss") {
            node.addChildNode(Boss.shared.spawnBoss())
            Boss.shared.level = self.level
            Boss.shared.spawned {
                
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        self.updateLabel()
        switch frame.worldMappingStatus {
        case .extending, .mapped : prepareConnect()
        default: return
        }
    }
    
    
    
    // MARK: - Multiuser shared session
    
    
    /// - Tag: ReceiveData
    func receivedData(_ data: Data, from peer: MCPeerID) {
        do {
            if let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) {
                let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = .horizontal
                configuration.initialWorldMap = worldMap
                if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
                    configuration.frameSemantics.insert(.personSegmentationWithDepth)
                }
                sceneView?.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
            }
        } catch  {
            print("can't decode data recieved from \(peer)")
        }
        
        guard let dataString = String(data: data, encoding: .utf8) else {return}
        print(#function, dataString)
        if dataString == "false" || dataString == "true"{
            Boss.shared.attacked(critical: dataString == "true")
            self.shareBossStatus(val: dataString == "true")
            return
        }
        if let val = Int(dataString) {
            if val >= 11 && val <= 13 {
                self.level = val
                Boss.shared.level = val
                DispatchQueue.main.async {
                    self.setupUI()
                }
            }else {
                Boss.shared.health = val
                Boss.shared.checkHP()
            }
        }
    }
    
}

