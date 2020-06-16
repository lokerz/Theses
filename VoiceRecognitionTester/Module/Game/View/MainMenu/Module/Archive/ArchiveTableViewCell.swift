//
//  ArchiveTableViewCell.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 16/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit

class ArchiveTableViewCell: UITableViewCell {
    @IBOutlet weak var lblPinyin: UILabel!
    @IBOutlet weak var lblEnglish: UILabel!
    @IBOutlet weak var lblHanzi: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    var action : (()->Void)?
    var progress = 0
    
    func configureView(word : WordJSON){
        self.lblPinyin.text = word.Pinyin
        self.lblEnglish.text = word.English
        self.lblHanzi.text = word.Chinese
        self.progressLabel.text = "\(progress)/25"
        self.progressBar.progress = Float(progress) / 25
    }
    
    @IBAction func actionTutorial(_ sender: Any) {
        self.action?()
    }
}
