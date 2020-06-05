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
    @IBOutlet weak var progressBar: UIProgressView!
    
    let _HEALTH = 10
    let TIME_OUT: Double = 5
    let TIME_OUT_LONG: Double = 20
    
    var health = 0
    var i = 0
    var arrIndex = [Int]()
    let skip = "99"
    let skip2 = "QQ"
    let language = "zh-CN"
    let voiceManager = VoiceRecognitionManager.instance
    let wordManager = WordManager.instance
    
    var timeRemaining = Double()
    var timer = Timer()
    
    var startAction: () -> Void = {}
    
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
        
        self.resetGame()
        self.setupVoice()
        self.setupIndex()
        self.setupProgressBar()
    }
    
    func setupVoice(){
        voiceManager.delegate = self
        voiceManager.setLocale(language: language)
        voiceManager.supportedLocale()
    }
    
    func setupIndex(){
        for i in 0..<self.wordManager.words.count{
            self.arrIndex.append(i)
        }
        //        self.arrIndex.shuffle()
    }
    
    func setupProgressBar(){        self.progressBar.layer.masksToBounds = false
        self.progressBar.layer.cornerRadius = 5
        self.progressBar.progress = 1
    }
    
    func setupWords(){
        self.lblHealth.text = "x" + String(health)
        self.lblHanze.text = self.wordManager.words[self.arrIndex[i]].data.Chinese
        self.lblPinyin.text = self.wordManager.words[self.arrIndex[i]].data.Pinyin
        self.lblEnglish.text = self.wordManager.words[self.arrIndex[i]].data.English
        self.voiceManager.recordAndRecognizeSpeech()
    }
    
    func nextWord(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            guard self.i < self.wordManager.words.count else {
                self.resetGame()
                return
            }
            self.resetLabel()
            self.setupWords()
            self.startTimer()
        }
    }
    
    func resetGame(){
        self.i = 0
        self.health = _HEALTH
        self.hideLabel(state: true)
        self.btnStart.isHidden = false
        self.lblHealth.isHidden = true
    }
    
    func startTimer(){
        self.progressBar.progress = 1
        self.timeRemaining = i == self.wordManager.words.count - 1 ? self.TIME_OUT_LONG : self.TIME_OUT
        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(runningTimer), userInfo: nil, repeats: true)
    }
    
    @objc func runningTimer(){
        let time = i == self.wordManager.words.count - 1 ? self.TIME_OUT_LONG : self.TIME_OUT
        self.timeRemaining -= 0.001
        self.progressBar.setProgress(Float(self.timeRemaining / time), animated: true)
        if timeRemaining <= 0 {
            self.lose()
        }
    }
    
    func hideLabel(state: Bool){
        self.lblHealth.isHidden = state
        self.lblHanze.isHidden = state
        self.lblPinyin.isHidden = state
        self.lblEnglish.isHidden = state
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
    }
    
    @IBAction func actionStart(_ sender: Any) {
        guard !self.wordManager.words.isEmpty else {return}
        self.startAction()
        self.setupWords()
        self.startTimer()
        self.hideLabel(state: false)
        self.btnStart.isHidden = true
    }
    
    func win(){
        self.timer.invalidate()
        self.voiceManager.stop()
        self.i += 1
        self.setLabel(state: true)
        self.nextWord()
    }
    
    func lose(){
        self.timer.invalidate()
        self.voiceManager.stop()
        self.i += 1
        self.health -= 1
        self.nextWord()
    }
}

extension GameplayUIView : VoiceRecognitionDelegate{
    
    func updateText(text: String) {
        let tempHanze = text.trimPunctuation()
        let tempPinyin = text.trimPunctuation().k3.pinyin
        let textHanze = self.lblHanze.text!.trimPunctuation()
        let textPinyin = self.lblPinyin.text!.trimPunctuation()
        
        print("index: ", i)
        print(tempHanze, tempPinyin)
        print(textHanze, textPinyin)
        print()

        if text.contains(skip) || text.contains(skip2) {
            self.lose()
        } else if tempPinyin.contains(textPinyin) || tempHanze.contains(textHanze){
            self.win()
        } else {
            self.setLabel(state: false)
        }
        
        
        
    }
}
