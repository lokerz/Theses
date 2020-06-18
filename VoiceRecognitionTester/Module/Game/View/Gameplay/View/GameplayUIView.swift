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
    @IBOutlet weak var lblLevel: UILabel!
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
    var winView : PauseView?
    var retryView : PauseView?

    var index           = 0
    var sentenceIndex   = 0

    var sentences       = [Sentence]()
    var words           = [Word]()
    var currentWord     : Word?
    var currentSentence : Sentence?

    let boss            = Boss.shared
    let player          = Player.shared
    let hintManager     = HintManager.shared
    let gameManager     = GameManager.shared
    let voiceManager    = VoiceRecognitionManager.instance
    let wordManager     = WordManager.instance
    let timeManager     = TimerManager.shared
    let speechManager   = SpeechManager.shared
    let levelManager    = LevelManager.shared
    
    var isSpeaking      = false
    var isRecording     = false
    var isSentence      = true
    
    var startAction: (() -> Void)?
    var stopAction: (()-> Void)?
    var nextLevelAction : (()-> Void)?
    
    var level = 0 {
        didSet {
            self.sentences = [Sentence]()
            self.sentences = level > 100 ? wordManager.sentences : wordManager.sentences.filter{$0.Level == self.level}.shuffled() 
            self.lblLevel.text = "-LEVEL \(level)-"
        }
    }
    
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
        self.setupWinView()
        self.setupRetryView()
                
        self.gameManager.reset?()
    }
    
    func nextWord(delay: DispatchTime = .now() + 1){
        guard !player.isDead && !boss.isDead else {return}
        if isSentence {
            self.words = self.sentences[sentenceIndex].Words
            self.isSentence = false
        }
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.isRecording = false
            self.timeManager.reset()
            self.resetLabel()
            if self.index < self.words.count {
                self.setupWord(word: self.words[self.index])
                self.index += 1
            } else {
                self.isSentence = true
                self.currentSentence = self.sentences[self.sentenceIndex]
                let word = Word(Chinese: self.sentences[self.sentenceIndex].Chinese,
                                Pinyin: self.sentences[self.sentenceIndex].Pinyin,
                                English: self.sentences[self.sentenceIndex].English)
                self.setupWord(word: word)

                self.sentenceIndex = self.sentenceIndex == self.sentences.count - 1 ? 0 : self.sentenceIndex + 1
                self.index = 0
            }
        }
    }
    
    func setupWord(word: Word){
        self.currentWord = word
        self.lblHanze.text = word.Chinese
        self.lblPinyin.text = word.Pinyin
        self.lblEnglish.text = word.English
        self.timeManager.start(critical: isSentence)
        self.voiceManager.record()
        self.isRecording = true
    }
    
    func hideUI(state: Bool){
        self.btnStart.isHidden = !state
        self.lblLevel.isHidden = !state
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
        guard !self.sentences.isEmpty else {return}
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
        
        if !isSentence {
            if skip.contains(where: text.contains) {
                self.gameManager.correct?()
            } else if tempPinyin.contains(textPinyin) || tempHanze.contains(textHanze){
                self.gameManager.correct?()
            } else {
                self.setLabel(state: false)
            }
        } else {
            if skip.contains(where: text.contains) {
                self.gameManager.correct?()
            } else {
                self.specialCheck(text: text.trimPunctuation())
            }
        }
    }
    
    func specialCheck(text: String){
        var correctWords = [String:Bool]()
        let tempHanze    = text
        let tempPinyin   = text.k3.pinyin
        
        guard let words = self.currentSentence?.Words else {return}
        
        for word in words {
            if tempHanze.contains(word.Chinese) || tempPinyin.contains(word.Pinyin) {
                correctWords[word.Chinese] = true
                changeColor(words: correctWords)
            }
        }
        
        if correctWords.count == words.count {
            self.gameManager.correct?()
        }
    }
    
    func changeColor(words: [String : Bool]){
        guard let text = self.lblHanze.text else {return}
        let attributedText = NSMutableAttributedString(string: text)
        let color = #colorLiteral(red: 0.3411764706, green: 0.6235294118, blue: 0.168627451, alpha: 1)
        for word in words {
            if let range = text.range(of: word.key)?.nsRange {
                attributedText.addAttribute(.foregroundColor, value: color, range: range)
            }
        }
        
        self.lblHanze.attributedText = attributedText
    }
}

extension GameplayUIView {
    
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
            self.gameManager.wrong?()
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
            self.gameManager.gameOver(state: true)
        }
        boss.revived = {
            
        }
    }
    
    func setupPlayer() {
        player.update = { val in
            self.lblHealth.text = "x" + String(val)
        }
        player.dead = {
            self.gameManager.gameOver(state: false)
        }
    }
    
    func setupGameManager(){
        gameManager.start = {
            self.startAction?()
            self.hideUI(state: false)
            self.hintManager.check()
            self.nextWord(delay: .now())
        }
        
        gameManager.reset = {
            self.index = 0
            self.sentenceIndex = 0
            
            self.isSpeaking      = false
            self.isRecording     = false
            self.isSentence      = true
            
            self.timeManager.reset()
            self.boss.revive()
            self.player.revive()
            
            self.hideUI(state: true)
            self.resetLabel()
        }
        
        gameManager.wrong = {
            self.timeManager.stop()
            self.voiceManager.stop()
            self.nextWord()
        }
        
        gameManager.correct = {
            if !self.isSentence {
                self.wordManager.saveWord(self.currentWord)
            }
            self.boss.attacked(critical: self.isSentence)
            self.timeManager.stop()
            self.voiceManager.stop()
            self.setLabel(state: true)
            self.nextWord()
        }
        
        gameManager.pause = {
            self.btnPause.isHidden = true
            self.pauseView?.isHidden = false
            self.timeManager.stop()
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
        
        gameManager.win = {
            self.hintManager.add()
            self.levelManager.unlockLevel(level: self.level + 1)
            
            self.winView?.isHidden = false
            self.speechManager.stop()
            self.timeManager.stop()
            self.voiceManager.stop()
        }
        
        gameManager.lose = {
            self.levelManager.unlockLevel(level: self.level + 1)
            
            self.retryView?.isHidden = false
            self.speechManager.stop()
            self.timeManager.stop()
            self.voiceManager.stop()
        }
        
    }
    
    func setupHintManager(){
        hintManager.hint_method = {
            guard let text = self.currentWord?.Chinese else {return}
            self.timeManager.stop()
            self.voiceManager.stop()
            self.speechManager.speak(text: text)
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
        guard let view = pauseView else {return}
        view.yes_method = {
            self.gameManager.stop?()
            self.gameManager.reset?()
        }
        view.no_method = {
            self.pauseView?.isHidden = true
            self.gameManager.resume?()
        }
        self.addSubview(view)
        view.isHidden = true
    }
    
    func setupWinView(){
        winView = PauseView(frame: self.frame)
        guard let view = winView else {return}
        view.lblText.text = "YOU WIN! NEXT LEVEL?"
        view.yes_method = {
            self.retryView?.isHidden = true
            self.nextLevelAction?()
            self.gameManager.reset?()
        }
        view.no_method = {
            self.gameManager.stop?()
        }
        self.addSubview(view)
        view.isHidden = true
    }
    
    func setupRetryView(){
        retryView = PauseView(frame: self.frame)
        guard let view = retryView else {return}
        view.lblText.text = "YOU LOSE! TRY AGAIN?"
        view.yes_method = {
            self.retryView?.isHidden = true
            self.gameManager.reset?()
        }
        view.no_method = {
            self.gameManager.stop?()
        }
        self.addSubview(view)
        view.isHidden = true
    }
    
}

extension Range where Bound == String.Index {
    var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset, length: self.upperBound.encodedOffset - self.lowerBound.encodedOffset)
    }
}
