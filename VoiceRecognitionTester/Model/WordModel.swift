//
//  HSK1.swift
//  VoiceRecognitionTester
//
//  Created by Ridwan Abdurrasyid on 15/03/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import Foundation

struct Word {
    var id : Int
    var data : WordJSON
}

struct WordJSON : Decodable{
    var Chinese : String
    var Pinyin : String
    var English : String
}
