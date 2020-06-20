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
        vc.create_method = { val in
            let vc = MultiplayerGameplayViewController(level: val, create: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func actionJoin(_ sender: Any) {
        let vc = MultiplayerGameplayViewController(level: 1, create: false)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
