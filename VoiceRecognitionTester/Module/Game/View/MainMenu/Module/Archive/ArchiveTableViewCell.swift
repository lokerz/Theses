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
    
    @IBOutlet weak var imgBronze: UIImageView!
    @IBOutlet weak var imgSilver: UIImageView!
    @IBOutlet weak var imgGold: UIImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var silverDistance: NSLayoutConstraint!
    
    var progress = 0
    var action : (()->Void)?
    
    func configureView(word : Word){
        self.lblPinyin.text = word.Pinyin
        self.lblEnglish.text = word.English
        self.lblHanzi.text = word.Chinese
        
        self.progress = WordManager.instance.archivedWords[word.Chinese] ?? 10
        self.progress = self.progress > 25 ? 25 : self.progress
        self.progressLabel.text = "\(progress)/25"
        self.progressBar.progress = Float(progress) / 25
        
        imgBronze.isHidden = true
        imgSilver.isHidden = true
        imgGold.isHidden = true

        if progress > 0 {
            imgBronze.isHidden = false
        }
        if progress >= 10 {
            imgSilver.isHidden = false
        }
        if progress == 25 {
            imgGold.isHidden = false
            self.progressLabel.isHidden = true
        }
        
        silverDistance.constant = progressBar.frame.width * 0.4 - imgSilver.frame.width / 2

    }
    
    func updateSize(){
        self.lblPinyin.font = UIFont.boldSystemFont(ofSize: self.frame.height * 0.2)
        self.lblPinyin.adjustsFontSizeToFitWidth = true
        
        self.lblEnglish.font = UIFont.systemFont(ofSize: self.frame.height * 0.2)
        self.lblEnglish.adjustsFontSizeToFitWidth = true

        self.lblHanzi.font = UIFont.boldSystemFont(ofSize: self.frame.height * 0.5)
        self.lblHanzi.adjustsFontSizeToFitWidth = true
        
        self.progressLabel.font = UIFont.systemFont(ofSize: self.frame.height * 0.15)
        self.progressLabel.adjustsFontSizeToFitWidth = true

    }
    
    @IBAction func actionTutorial(_ sender: Any) {
        self.action?()
    }
}
