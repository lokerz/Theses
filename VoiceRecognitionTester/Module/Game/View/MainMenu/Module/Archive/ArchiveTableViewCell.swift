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
    
    var progress = 0
    var action : (()->Void)?
    
    func configureView(word : Word){
        self.lblPinyin.text = word.Pinyin
        self.lblEnglish.text = word.English
        self.lblHanzi.text = word.Chinese
        
        self.progress = WordManager.instance.archivedWords[word.Chinese] ?? 0
        self.progressLabel.text = "\(progress)/25"
        self.progressBar.progress = Float(progress) / 25
        
        print(#function, word.Chinese, word.Pinyin, progress, Float(progress) / 25)

    }
    
    @IBAction func actionTutorial(_ sender: Any) {
        self.action?()
    }
}
