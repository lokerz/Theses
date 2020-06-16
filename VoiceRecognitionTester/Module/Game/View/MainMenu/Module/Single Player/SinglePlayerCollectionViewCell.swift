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
        btnLevel.setTitle("LEVEL \(level)", for: .normal)
    }
    
    @IBAction func actionButton(_ sender: Any) {
        action?()
    }
    
}
