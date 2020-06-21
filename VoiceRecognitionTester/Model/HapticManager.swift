//
//  HapticManager.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 21/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import Foundation
import UIKit
import CoreHaptics

class HapticManager {
    static var shared = HapticManager()
    var hapticEngine : CHHapticEngine?
    
    init() {
        do {
            hapticEngine = try CHHapticEngine()
            
            try hapticEngine?.start()
            
        } catch let error {
            print (error)
        }
    }
    
    func play(_ i : Int) {
            print("Running \(i)")
            
            
            
            switch i {
            case 1:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            case 2:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                
            case 3:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
                
            case 4:
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                
            case 5:
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                
            case 6:
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
                
            default:
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
            
        }
    }
}

extension UIButton {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        HapticManager.shared.play(2)
    }
}

