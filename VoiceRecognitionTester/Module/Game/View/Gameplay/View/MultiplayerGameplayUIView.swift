//
//  MultiplayerGameplayUIView.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 20/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import Foundation

import UIKit

class MultiplayerGameplayUIView : GameplayUIView {
    
    
    override func hideUI(state: Bool){
        self.btnStart.isHidden = !state
        self.lblLevel.isHidden = !state
        self.imgHealth.isHidden = true
        self.btnHint.isHidden = state
        self.timerBar.isHidden = state
        self.lblHealth.isHidden = true
        self.lblHanze.isHidden = state
        self.lblPinyin.isHidden = state
        self.lblEnglish.isHidden = state
        self.HPBar.isHidden = state
        self.containerHPBar.isHidden = state
    }
    
    override func setupTimer(){
        super.setupTimer()
        
        timeManager.done_method = {
            self.btnHint.isEnabled = false
            self.timeManager.stop()
            self.voiceManager.stop()
            self.boss.attack() {
                self.gameManager.wrong?()
            }
        }
    }
    
    override func setupPlayer() {
        //empty
    }
    
    override func setupGameManager() {
        super.setupGameManager()
        gameManager.win = {
            self.endView?.isHidden = false
            self.speechManager.stop()
            self.timeManager.stop()
            self.voiceManager.stop()
        }
        
        gameManager.lose = {
            self.retryView?.isHidden = false
            self.speechManager.stop()
            self.timeManager.stop()
            self.voiceManager.stop()
        }
    }
    
    
    
}
