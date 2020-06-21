//
//  SinglePlayerCollectionViewCell.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 16/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit

class SinglePlayerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var btnLevel: UIButton!
    
    var action : (()->Void)?
    
    func configureView(level: Int){
        btnLevel.setTitle(LevelManager.shared.TOTAL_LEVEL == level ? "BONUS" : "LEVEL \(level)", for: .normal)
    }
    
    func updateSize(){
        btnLevel.titleLabel?.adjustsFontSizeToFitWidth = true
        btnLevel.titleLabel?.font = UIFont(name: "Phosphate-Inline", size: btnLevel.frame.height * 0.33)
    }
    
    @IBAction func actionButton(_ sender: Any) {
        action?()
    }
    
}
