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
    @IBOutlet weak var lblMandarin: UILabel!
    @IBOutlet weak var lblLatin: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var i = 0
    var arrIndex = [Int]()
    let skip = "99"
    let skip2 = "QQ"
    let language = "zh-CN"
    let voiceManager = VoiceRecognitionManager.instance
    let wordManager = WordManager.instance
    
    let TIME_OUT: Double = 5
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
        
        self.hideLabel(state: true)
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
        self.lblMandarin.text = self.wordManager.words[self.arrIndex[i]].data.Chinese
        self.lblLatin.text = self.wordManager.words[self.arrIndex[i]].data.Pinyin
        self.voiceManager.recordAndRecognizeSpeech()
    }
    
    func nextWord(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.resetLabel()
            self.setupWords()
            self.startTimer()
        }
    }
    
    func startTimer(){
        self.progressBar.progress = 1
        self.timeRemaining = self.TIME_OUT
        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(runningTimer), userInfo: nil, repeats: true)
    }
    
    @objc func runningTimer(){
        self.timeRemaining -= 0.001
        self.progressBar.setProgress(Float(self.timeRemaining / self.TIME_OUT), animated: true)
        if timeRemaining <= 0 {
            self.lose()
        }
    }
    
    func hideLabel(state: Bool){
        self.lblMandarin.isHidden = state
        self.lblLatin.isHidden = state
    }
    
    func setLabel(state: Bool) {
        self.lblMandarin.textColor = !state ? #colorLiteral(red: 0.863093964, green: 0, blue: 0, alpha: 1):#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        self.lblLatin.textColor = self.lblMandarin.textColor
    }
    
    func resetLabel(){
        self.lblMandarin.textColor = .white
        self.lblLatin.textColor = .white
    }
    
    @IBAction func actionStart(_ sender: Any) {
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
        self.nextWord()
    }
}

extension GameplayUIView : VoiceRecognitionDelegate{
    
    func updateText(text: String) {
        let tempMandarin = text.trimPunctuation()
        let tempLatin = text.trimPunctuation().k3.pinyin
        
        if text.contains(skip) || text.contains(skip2) {
            self.lose()
        } else if tempLatin.contains(self.lblLatin.text!) || tempMandarin.contains(self.lblMandarin.text!){
            self.win()
        } else {
            self.setLabel(state: false)
        }
        
        
        
    }
}
