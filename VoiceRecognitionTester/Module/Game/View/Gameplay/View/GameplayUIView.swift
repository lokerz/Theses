//
//  GameplayUIView.swift
//  VoiceRecognitionTester
//
//  Created by Ridwan Abdurrasyid on 17/05/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit

class GameplayUIView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lblHanze: UILabel!
    @IBOutlet weak var lblPinyin: UILabel!
    @IBOutlet weak var lblEnglish: UILabel!
    @IBOutlet weak var lblHealth: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnHint: UIButton!
    @IBOutlet weak var timerBar: UIProgressView!
    @IBOutlet weak var HPBar: UIProgressView!
    @IBOutlet weak var containerHPBar: UIImageView!
    var pauseView : PauseView?
    
    var index           = -1
    
    let boss            = Boss.shared
    let player          = Player.shared
    let gameManager     = GameManager.shared
    let voiceManager    = VoiceRecognitionManager.instance
    let wordManager     = WordManager.instance
    let timeManager     = TimerManager.shared
    let speechManager   = SpeechManager.shared
    
    var startAction: (() -> Void)?
    var stopAction: (()-> Void)?
    
    override func awakeFromNib() {
        self.initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initView()
    }
    
    private func initView(){
        Bundle.main.loadNibNamed("GameplayUIView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.setupBoss()
        self.setupPlayer()
        self.setupTimer()
        
        self.setupVoiceManager()
        self.setupSpeechManager()
        self.setupGameManager()
        self.setupPauseView()
        
        self.gameManager.reset?()
    }
        
    func nextWord(){
        self.index += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.index < self.wordManager.words.count {
                self.timeManager.reset()
                self.resetLabel()
                self.setupWords()
            } else {
                self.gameManager.reset?()
            }
        }
    }
    
    func setupWords(){
        self.lblHanze.text = self.wordManager.words[index].data.Chinese
        self.lblPinyin.text = self.wordManager.words[index].data.Pinyin
        self.lblEnglish.text = self.wordManager.words[index].data.English
        self.speechManager.speak(text: self.wordManager.words[index].data.Chinese)
    }
    
    func hideUI(state: Bool){
        self.btnStart.isHidden = !state
        self.lblHealth.isHidden = state
        self.lblHanze.isHidden = state
        self.lblPinyin.isHidden = state
        self.lblEnglish.isHidden = state
        self.HPBar.isHidden = state
        self.containerHPBar.isHidden = state
    }
    
    func setLabel(state: Bool) {
        let color = !state ? #colorLiteral(red: 0.863093964, green: 0, blue: 0, alpha: 1):#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        self.lblHanze.textColor = color
        self.lblPinyin.textColor = color
        self.lblEnglish.textColor = color
    }
    
    func resetLabel(){
        let color = UIColor.black
        self.lblHanze.textColor = color
        self.lblPinyin.textColor = color
        self.lblEnglish.textColor = color
        self.lblHanze.text = ""
        self.lblPinyin.text = ""
        self.lblEnglish.text = ""
    }
    
    @IBAction func actionStart(_ sender: Any) {
        guard !self.wordManager.words.isEmpty else {return}
        self.gameManager.start?()
    }
    
    @IBAction func actionPause(_ sender: Any) {
        self.gameManager.pause?()
    }
    
    @IBAction func actionHint(_ sender: Any) {
        
    }
}

extension GameplayUIView : VoiceRecognitionDelegate{
    
    func updateText(text: String) {
        let skip        = ["99", "QQ"]
        let tempHanze   = text.trimPunctuation()
        let tempPinyin  = text.trimPunctuation().k3.pinyin
        let textHanze   = self.lblHanze.text!.trimPunctuation()
        let textPinyin  = self.lblPinyin.text!.trimPunctuation()
        
        print("index: ", index)
        print("player: ", tempHanze, tempPinyin)
        print(textHanze, textPinyin)
        print()
        
//        if self.wordManager.words[index].data.Sentence {
//            self.specialCheck(tempHanze, tempPinyin)
//        } else
        if skip.contains(where: text.contains) {
            self.gameManager.win?()
        } else if tempPinyin.contains(textPinyin) || tempHanze.contains(textHanze){
            self.gameManager.win?()
        } else {
            self.setLabel(state: false)
        }
    }
    
//    func specialCheck(_ hanze : String, _ pinyin : String) {
//        let textHanze   = self.lblHanze.text!.trimPunctuation()
//        let textPinyin  = self.lblPinyin.text!.trimPunctuation()
//        
//        
//        
//        
//        if pinyin.contains(textPinyin) || hanze.contains(textHanze){
//            self.gameManager.win()
//        }
//    }
}

extension GameplayUIView {
    func setupVoiceManager(){
        voiceManager.delegate = self
    }

    func setupSpeechManager(){
        speechManager.done_method = {
            self.timeManager.start(critical: self.wordManager.words[self.index].data.Sentence)
            self.voiceManager.recordAndRecognizeSpeech()
        }
    }
    
    func setupTimer(){
        self.timerBar.layer.masksToBounds = false
        self.timerBar.layer.cornerRadius = 5
        self.timerBar.progress = 1

        timeManager.set_method = { val in
            self.timerBar.setProgress(val, animated: true)
        }
        
        timeManager.done_method = {
            self.player.attacked()
            self.gameManager.lose?()
        }
        
        timeManager.reset_method = {
            self.timerBar.progress = 1
        }
    }
    
    func setupBoss(){
        boss.update = { val in
            self.HPBar.setProgress(val, animated: true)
        }
        boss.dead = {
            //PLAYER WIN
        }
        boss.revived = {
            
        }
    }
    
    func setupPlayer() {
        player.update = { val in
            self.lblHealth.text = "x" + String(val)
        }
        player.dead = {
            //PLAYER LOSE
        }
    }
    
    func setupGameManager(){
        gameManager.start = {
            self.startAction?()
            self.hideUI(state: false)
            
            self.nextWord()
        }
        
        gameManager.reset = {
            self.index = -1
            self.timeManager.reset()
            self.boss.revive()
            self.player.revive()
            
            self.hideUI(state: true)
            self.resetLabel()
        }
        
        gameManager.lose = {
            self.timeManager.stop()
            self.voiceManager.stop()
            self.nextWord()
        }
        
        gameManager.win = {
            self.boss.attacked(critical: self.wordManager.words[self.index].data.Sentence)
            self.timeManager.stop()
            self.voiceManager.stop()
            self.setLabel(state: true)
            self.nextWord()
        }
        
        gameManager.pause = {
            self.btnPause.isHidden = true
            self.pauseView?.isHidden = false
        }
        
        gameManager.resume = {
            self.btnPause.isHidden = false
        }
        
        gameManager.stop = {
            self.stopAction?()
        }
        
    }
    
    func setupPauseView(){
        pauseView = PauseView(frame: self.frame)
        guard let pauseView = pauseView else {return}
        pauseView.yes_method = {
            self.gameManager.stop?()
        }
        pauseView.no_method = {
            self.pauseView?.isHidden = true
            self.gameManager.resume?()
        }
        self.addSubview(pauseView)
        pauseView.isHidden = true
    }
}
