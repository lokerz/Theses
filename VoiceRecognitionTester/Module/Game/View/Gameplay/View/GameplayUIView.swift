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
    @IBOutlet weak var imgHealth: UIImageView!
    @IBOutlet weak var lblHealth: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnHint: UIButton!
    @IBOutlet weak var timerBar: UIProgressView!
    @IBOutlet weak var HPBar: UIProgressView!
    @IBOutlet weak var containerHPBar: UIImageView!
    var pauseView : PauseView?
    
    var index           = -1
    var hints           = 10
    var level           = 0
    var sentences       = [Sentence]()
    var words           = [Word]()

    let boss            = Boss.shared
    let player          = Player.shared
    let hintManager     = HintManager.shared
    let gameManager     = GameManager.shared
    let voiceManager    = VoiceRecognitionManager.instance
    let wordManager     = WordManager.instance
    let timeManager     = TimerManager.shared
    let speechManager   = SpeechManager.shared
    
    var isSpeaking      = false
    var isRecording     = false
    
    var delay : DispatchTime?
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
        self.setupHintManager()
        self.setupPauseView()
                
        self.gameManager.reset?()
    }
      
    func nextSentence() {
        
    }
    
    func nextWord(delay: DispatchTime = .now() + 1){
        self.index += 1
        self.isRecording = false
        DispatchQueue.main.asyncAfter(deadline: delay) {
            if self.index < self.words.count {
                self.timeManager.reset()
                self.resetLabel()
                self.setupWords()
            } else {
//                self.gameManager.reset?()
            }
        }
    }
    
    func setupWords(){
        self.lblHanze.text = self.words[index].Chinese
        self.lblPinyin.text = self.words[index].Pinyin
        self.lblEnglish.text = self.words[index].English
        self.timeManager.start()
        self.isRecording = true
        self.voiceManager.record()
    }
    
    func hideUI(state: Bool){
        self.btnStart.isHidden = !state
        self.imgHealth.isHidden = state
        self.btnHint.isHidden = state
        self.timerBar.isHidden = state
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
        self.lblHanze.textColor = #colorLiteral(red: 0.4573255777, green: 0.3877093494, blue: 0.1551564038, alpha: 1)
        self.lblPinyin.textColor = #colorLiteral(red: 0.4329447448, green: 0.5243666172, blue: 0.1861178577, alpha: 1)
        self.lblEnglish.textColor = #colorLiteral(red: 0.4573255777, green: 0.3877093494, blue: 0.1551564038, alpha: 1)
        self.lblHanze.text = ""
        self.lblPinyin.text = ""
        self.lblEnglish.text = ""
    }
    
    @IBAction func actionStart(_ sender: Any) {
        self.setupWordsArray()
        guard !self.words.isEmpty else {return}
        self.gameManager.start?()
    }
    
    @IBAction func actionPause(_ sender: Any) {
        self.gameManager.pause?()
    }
    
    @IBAction func actionHint(_ sender: Any) {
        self.hintManager.hint()
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
        
//        if self.words[index].Sentence {
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
    
    func setupWordsArray(){
        if let words = self.sentences.first?.Words{
            self.words = words
        }
    }
    
    func setupVoiceManager(){
        voiceManager.delegate = self
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
            self.hintManager.reset()
            self.nextWord(delay: .now())
        }
        
        gameManager.reset = {
            self.index = -1
            self.hints = 10
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
            self.boss.attacked()
            self.timeManager.stop()
            self.voiceManager.stop()
            self.setLabel(state: true)
            self.nextWord()
        }
        
        gameManager.pause = {
            self.btnPause.isHidden = true
            self.pauseView?.isHidden = false
            self.timeManager.pause()
            if self.isRecording {
                self.voiceManager.stop()
            }
            if self.isSpeaking {
                self.speechManager.pause()
            }
        }
        
        gameManager.resume = {
            self.btnPause.isHidden = false
            if self.isSpeaking {
                self.speechManager.resume()
            } else if self.isRecording {
                self.voiceManager.record()
                self.timeManager.resume()
            }
        }
        
        gameManager.stop = {
            self.speechManager.stop()
            self.timeManager.stop()
            self.voiceManager.stop()
            self.stopAction?()
        }
        
    }
    
    func setupHintManager(){
        hintManager.hint_method = {
            self.timeManager.pause()
            self.voiceManager.stop()
            self.speechManager.speak(text: self.words[self.index].Chinese)
            self.isSpeaking = true
            self.btnHint.isEnabled = false
        }
        
        hintManager.update = { val in
            self.btnHint.setTitle("x\(val)", for: .normal)
            self.btnHint.isEnabled = val != 0
        }
    }
    
    func setupSpeechManager(){
        speechManager.done_method = {
            self.isSpeaking = false
            self.gameManager.resume?()
            self.hintManager.check()
        }
    }
    
    func setupPauseView(){
        pauseView = PauseView(frame: self.frame)
        guard let pauseView = pauseView else {return}
        pauseView.yes_method = {
            self.gameManager.reset?()
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
