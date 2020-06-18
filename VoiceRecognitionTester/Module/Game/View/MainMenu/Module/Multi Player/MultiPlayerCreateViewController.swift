//
//  MultiPlayerCreateViewController.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 16/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit

class MultiPlayerCreateViewController: BasePopUpViewController {
    @IBOutlet weak var imgEasy: UIImageView!
    @IBOutlet weak var imgNormal: UIImageView!
    @IBOutlet weak var imgHard: UIImageView!
    
    @IBOutlet weak var btnCreate: UIButton!
    
    var level = 101 {
        didSet {
            self.hideUI()
        }
    }
    
    var create_method: ((Int)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideUI()
    }
    
    func hideUI(){
        self.btnCreate.isEnabled = GameManager.shared.IS_MULTIPLAYER
        self.imgEasy.isHidden = level == 101 ? false : true
        self.imgNormal.isHidden = level == 102 ? false : true
        self.imgHard.isHidden = level == 103 ? false : true
    }
    
    
    @IBAction func actionEasy(_ sender: Any) {
        self.level = 101
    }
    
    @IBAction func actionNormal(_ sender: Any) {
        self.level = 102
    }
    
    @IBAction func actionHard(_ sender: Any) {
        self.level = 103
    }
    
    @IBAction func actionCreate(_ sender: Any) {
        self.dismiss()
        self.create_method?(self.level)
    }

}
