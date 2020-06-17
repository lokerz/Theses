//
//  ViewController.swift
//  VoiceRecognitionTester
//
//  Created by Ridwan Abdurrasyid on 03/03/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit
import K3Pinyin

class ViewController: UIViewController {
    let skip = "99"
    let skip2 = "QQ"
    let language = "zh-CN"
    let voiceManager = VoiceRecognitionManager.instance
    let wordManager = WordManager.instance
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var i = 0
    var id = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupVoice()
        self.setupWords()
        self.setupTextField()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            stackView.axis = .horizontal
        } else {
            print("Portrait")
            stackView.axis = .vertical
        }
    }
    
    func setupVoice(){
        voiceManager.delegate = self
        voiceManager.setLocale(language: language)
        voiceManager.supportedLocale()
    }
    
    func setupWords(){
        self.i = id - 1
        label3.text = ""
        label4.text = ""
    }
    
    func setupTextField(){
        self.goButton.isEnabled = false
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        if let index = Int(textField.text ?? "999") {
            if index < wordManager.words.count{
                goButton.isEnabled = true
            } else {
                goButton.isEnabled = false
            }
        }
    }
    
    @IBAction func button(_ sender: Any) {
        print(i)
        if i < wordManager.words.count {
            label3.text = wordManager.words[i].Chinese
            label4.text = wordManager.words[i].Pinyin
        
            label.text = ""
            label2.text = ""
            voiceManager.record()
            button.isEnabled = false
        } else {
            label4.text = ""
            label.text = ""
            label2.text = ""
            label3.text = "FINISHED"
            button.isEnabled = false
        }
    }
    
    @IBAction func goAction(_ sender: Any) {
        self.i = Int(textField.text!)! - 1
        label3.text = wordManager.words[i].Chinese
        label4.text = wordManager.words[i].Pinyin
        view.endEditing(true)
    }
}

extension ViewController : VoiceRecognitionDelegate{
    
    func updateText(text: String) {
        label.text = text.trimPunctuation()
        label2.text = text.trimPunctuation().k3.pinyin
        button.isEnabled = true
        
        if label2.text == label4.text || label.text == label3.text{
            self.i += 1
            voiceManager.stop()
        }
        
        if text == skip || text == skip2 {
            self.i += 1
            voiceManager.stop()
        }
    }
}
