//
//  MainMenuViewController.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 15/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit

class MainMenuViewController: BaseViewController {

    @IBOutlet weak var btnSingle: UIButton!
    @IBOutlet weak var btnMulti: UIButton!
    @IBOutlet weak var btnArchive: UIButton!
   
    @IBAction func actionSingle(_ sender: Any) {
        let vc = SinglePlayerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionMulti(_ sender: Any) {
        let vc = MultiplayerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionArchive(_ sender: Any) {
        let vc = ArchiveViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
