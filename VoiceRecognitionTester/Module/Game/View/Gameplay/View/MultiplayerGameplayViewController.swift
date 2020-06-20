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
    var btnCreate : UIButton?
    var multiGameUI: MultiplayerGameplayUIView?
    
    convenience init(level : Int, create: Bool) {
        self.init(nibName: "GameplayViewController", bundle: nil)
        self.level = level
        self.isCreator = create
        Boss.shared.isMultiplayer = true
    }
    
    override func setupScene(multiplayer: Bool = false){
        super.setupScene(multiplayer: true)
        self.multipeerSession = MultipeerSession(receivedDataHandler: self.receivedData)
        self.multipeerSession.isCreator = isCreator
    }
    
    override func setupUI(){
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
    
    @objc override func spawnBoss(sender: UITapGestureRecognizer) {
        guard isCreator else {return}
        super.spawnBoss(sender: sender)
    }
    
    override func respawnBoss() {
        guard isCreator else {return}
        super.respawnBoss()
    }
    
    func addConnectButton(){
        guard isCreator else {return}
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
        button.center = self.view.center
        button.setTitle("CONNECT", for: .normal)
        button.isEnabled = false
        button.titleLabel?.font = UIFont(name: "Phosphate-Inline", size: 50)
        self.btnCreate = button
        button.addTarget(self, action: #selector(connect), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func connect(){
        guard !(multipeerSession.connectedPeers.isEmpty) else {return}
        self.setupUI()
        self.shareLevel()
        self.btnCreate?.isHidden = true
        
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
    
    override func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let name = anchor.name, name.hasPrefix("Boss") {
            node.addChildNode(Boss.shared.spawnBoss())
            Boss.shared.level = self.level
            Boss.shared.spawned {
                if self.isCreator {
                    self.addConnectButton()
                }
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        print(multipeerSession!.connectedPeers.map({ $0.displayName }).joined(separator: ", "))
        switch frame.worldMappingStatus {
        case .notAvailable:
            self.btnCreate?.isEnabled = false
        case  .limited:
            self.btnCreate?.isEnabled = false
        case .extending:
            self.btnCreate?.isEnabled = !multipeerSession.connectedPeers.isEmpty
        case .mapped:
            self.btnCreate?.isEnabled = !multipeerSession.connectedPeers.isEmpty
        @unknown default:
            self.btnCreate?.isEnabled = true
        }
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required.
    }
    
    // MARK: - Multiuser shared session
    
    
    /// - Tag: ReceiveData
    func receivedData(_ data: Data, from peer: MCPeerID) {
        do {
            if let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) {
                let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = .horizontal
                configuration.initialWorldMap = worldMap
                if #available(iOS 13.0, *) {
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
            if val >= 10 && val <= 12 {
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

