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
    
    var level = 10 {
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
        self.imgEasy.isHidden = level == 10 ? false : true
        self.imgNormal.isHidden = level == 11 ? false : true
        self.imgHard.isHidden = level == 12 ? false : true
    }
    
    
    @IBAction func actionEasy(_ sender: Any) {
        self.level = 10
    }
    
    @IBAction func actionNormal(_ sender: Any) {
        self.level = 11
    }
    
    @IBAction func actionHard(_ sender: Any) {
        self.level = 12
    }
    
    @IBAction func actionCreate(_ sender: Any) {
        self.dismiss()
        self.create_method?(self.level)
    }

}
