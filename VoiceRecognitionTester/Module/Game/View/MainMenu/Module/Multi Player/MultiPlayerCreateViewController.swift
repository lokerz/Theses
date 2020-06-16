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
    
    var level = 1 {
        didSet {
            self.hideUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideUI()
    }
    
    func hideUI(){
        self.imgEasy.isHidden = level == 1 ? false : true
        self.imgNormal.isHidden = level == 2 ? false : true
        self.imgHard.isHidden = level == 3 ? false : true
    }
    
    
    @IBAction func actionEasy(_ sender: Any) {
        self.level = 1
    }
    
    @IBAction func actionNormal(_ sender: Any) {
        self.level = 2
    }
    
    @IBAction func actionHard(_ sender: Any) {
        self.level = 3
    }
    
    @IBAction func actionCreate(_ sender: Any) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
