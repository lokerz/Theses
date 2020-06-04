//
//  WordManager.swift
//  VoiceRecognitionTester
//
//  Created by Ridwan Abdurrasyid on 15/03/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import Foundation

class WordManager {
    static var instance = WordManager()
    var words = [Word]()
    
    init() {
        loadWords()
    }
    
    func loadWords(){
        var arr = [WordJSON]()
        let path = Bundle.main.path(forResource: "HSK1_2", ofType: "json")!
        guard let data = NSData(contentsOfFile: path) else {return}
        
        do{
            arr = try JSONDecoder().decode([WordJSON].self, from: data as Data)
        }catch{
            print(error)
        }
        
        for i in 0..<arr.count{
            words.append(Word(id: i, data: arr[i]))
        }
    }
}
