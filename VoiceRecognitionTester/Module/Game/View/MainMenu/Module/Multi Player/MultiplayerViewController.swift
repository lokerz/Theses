//
//  MultiplayerViewController.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 16/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit

class MultiplayerViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitle(title: .Multi)
        self.setupBackButton()
    }
    
    @IBAction func actionCreate(_ sender: Any) {
        let vc = MultiPlayerCreateViewController()
        self.present(vc, animated: true) {
            
        }
    }
    
    @IBAction func actionJoin(_ sender: Any) {
        let vc = MultiPlayerJoinViewController()
        self.present(vc, animated: true) {
            
        }
    }
}
