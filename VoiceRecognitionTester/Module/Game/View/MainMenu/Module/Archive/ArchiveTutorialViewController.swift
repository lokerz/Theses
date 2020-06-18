//
//  ArchiveTutorialViewController.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 16/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit

class ArchiveTutorialViewController: BasePopUpViewController, VoiceRecognitionDelegate {
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnTry: UIButton!
    
    @IBOutlet weak var lblPinyin: UILabel!
    @IBOutlet weak var lblHanzi: UILabel!
    @IBOutlet weak var lblEnglish: UILabel!
    
    let speechManager = SpeechManager.shared
    let voiceManager = VoiceRecognitionManager.instance
    var word : Word?
    
    convenience init(word: Word) {
        self.init()
        self.word = word
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.voiceManager.delegate = self
        self.configureView()
        
        self.speechManager.done_method = {
            self.btnTry.isEnabled = true
            self.btnPlay.isEnabled = true
        }
    }
    
    func configureView(){
        self.lblHanzi.text = word?.Chinese
        self.lblPinyin.text = word?.Pinyin
        self.lblEnglish.text = word?.English
    }
    
    @IBAction func actionPlay(_ sender: Any) {
        self.resetLabel()
        self.voiceManager.stop()
        guard let word = word else {return}
        speechManager.speak(text: word.Chinese)
        btnTry.isEnabled = false
        btnPlay.isEnabled = false
    }
    
    @IBAction func actionTry(_ sender: Any) {
        self.resetLabel()
        self.voiceManager.stop()
        self.speechManager.stop()
        self.voiceManager.record()
    }
    
    func updateText(text: String) {
        let tempHanze   = text.trimPunctuation()
        let tempPinyin  = text.trimPunctuation().k3.pinyin
        let textHanze   = self.lblHanzi.text!.trimPunctuation()
        let textPinyin  = self.lblPinyin.text!.trimPunctuation()
        
        print("player: ", tempHanze, tempPinyin)
        print(textHanze, textPinyin)
        
        if tempPinyin.contains(textPinyin) || tempHanze.contains(textHanze){
            self.setLabel(state: true)
            self.voiceManager.stop()
        } else {
            self.setLabel(state: false)
        }
    }
    
    func setLabel(state: Bool) {
        let color = !state ? #colorLiteral(red: 0.863093964, green: 0, blue: 0, alpha: 1):#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        self.lblHanzi.textColor = color
    }
    
    func resetLabel(){
        self.lblHanzi.textColor = #colorLiteral(red: 0.4573255777, green: 0.3877093494, blue: 0.1551564038, alpha: 1)
    }
    
}
