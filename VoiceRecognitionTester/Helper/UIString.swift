//
//  UIString.swift
//  VoiceRecognitionTester
//
//  Created by Ridwan Abdurrasyid on 15/03/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import Foundation

extension String {
    func trimPunctuation() -> String {
    return self.trimmingCharacters(in: .whitespacesAndNewlines)
                        .trimmingCharacters(in: .punctuationCharacters)
                        .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
