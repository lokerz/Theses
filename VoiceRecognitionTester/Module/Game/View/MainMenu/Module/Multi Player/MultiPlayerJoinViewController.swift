//
//  MultiPlayerJoinViewController.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 16/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit

class MultiPlayerJoinViewController: BasePopUpViewController {
    @IBOutlet weak var lblSearch: UILabel!
    @IBOutlet weak var imgSearch: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.animateLabel()
        self.animateImage()
    }

    func animateLabel(){
        var i = 0
        let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (_) in
            self.lblSearch.text = "Searching for host" + String(repeating: ".", count: i)
            i = i == 3 ? 0: i + 1
        }
    }
    
    func animateImage(){
        let spin = CABasicAnimation(keyPath: "transform.rotation")
        spin.duration = 1
        spin.repeatCount = .greatestFiniteMagnitude
        spin.fromValue = 0.0
        spin.toValue = Float(.pi * 1.0)
        self.imgSearch.layer.add(spin, forKey: nil)
    }

}
