//
//  MainMenuViewController.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 15/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit

class MainMenuViewController: BaseViewController {

    @IBAction func actionSingle(_ sender: Any) {
        SoundManager.shared.play()
        let vc = SinglePlayerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionMulti(_ sender: Any) {
        SoundManager.shared.play()
        let vc = MultiplayerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionArchive(_ sender: Any) {
        SoundManager.shared.play()
        let vc = ArchiveViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
