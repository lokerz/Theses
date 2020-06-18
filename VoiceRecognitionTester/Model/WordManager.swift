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
    
    
    func loadDefault(){
        self.archivedWords = defaults.object([String:Int].self, with: key) ?? [String : Int]()
    }
    
    func saveDefault(){
        defaults.set(object: archivedWords, forKey: key)
    }
    
    func saveWord(_ word : Word?){
        guard let word = word else {return}
        let val = archivedWords[word.Chinese] ?? 0
        if val == 0 {
            archivedWords[word.Chinese] = 1
        } else {
            archivedWords.updateValue(val + 1, forKey: word.Chinese)
        }
        self.saveDefault()
    }
}

extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }

    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}
