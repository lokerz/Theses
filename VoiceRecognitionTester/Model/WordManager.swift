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
    var archivedWords = [String : Int]()
    
    var key = "SoundBooWords"
    let defaults = UserDefaults.standard

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
    
    
    func loadDefaults(){
//        self.savedWords = defaults.array(forKey: key) as? [ArchivedWords] ?? [ArchivedWords]()
    }
    
    func saveDefaults(){
//        defaults.set(self.savedWords, forKey: key)
    }
    
    func saveWord(_ word : Word?){
        guard let word = word else {return}
        let val = archivedWords[word.Chinese] ?? 0
        archivedWords.updateValue(val + 1, forKey: word.Chinese)
        self.saveDefaults()
        return
            
        
//        archivedWords.
//            if archivedWord.Word?.Chinese == word.Chinese {
//                archivedWord.count! += 1
//            } else {
//                let archivedWord = ArchivedWord()
//                archivedWord.Word = word
//                archivedWord.count = 1
//                archivedWords.append(archivedWord)
            }
        }
        self.saveDefaults()
    }
}
