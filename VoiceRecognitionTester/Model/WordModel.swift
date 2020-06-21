//
//  HSK1.swift
//  VoiceRecognitionTester
//
//  Created by Ridwan Abdurrasyid on 15/03/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import Foundation

struct Sentence : Codable{
    var Level : Int
    var Chinese : String
    var Pinyin : String
    var English : String
    var Words : [Word]
}

struct Word : Codable, Equatable{
    var Chinese : String
    var Pinyin : String
    var English : String
    
    static func ==(lhs: Word, rhs: Word) -> Bool {
        return lhs.Chinese == rhs.Chinese
    }
}
