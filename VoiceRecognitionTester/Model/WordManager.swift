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
    var sentences = [Sentence]()
    var words = [Word]()
    
    init() {
        loadSentences()
        loadWords()
    }
    
    func loadSentences(){
        let path = Bundle.main.path(forResource: "HSK1_2", ofType: "json")!
        guard let data = NSData(contentsOfFile: path) else {return}
        
        do{
            self.sentences = try JSONDecoder().decode([Sentence].self, from: data as Data)
            print(sentences)
        }catch{
            print(error)
        }
    }
    
    func loadWords(){
        for sentence in sentences {
            for word in sentence.Words {
                self.words.append(word)
            }
        }
    }
}
