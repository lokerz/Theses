//
//  ArchiveViewController.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 16/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit

class ArchiveViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cellID = "ArchiveTableViewCell"
    
    var words = [Word]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitle(title: .Archive)
        self.setupBackButton()
        self.setupWords()
        self.setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateSize()
    }
    
    func setupWords(){
        let words = WordManager.instance.words.sorted{ $0.Pinyin < $1.Pinyin }
        self.words = words.removeDuplicates()
        self.tableView.reloadData()
    }
    
    func setupTableView(){
        self.tableView.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    func updateSize(){
        tableView.reloadData()
        tableView.isHidden = false
    }
}

extension ArchiveViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! ArchiveTableViewCell
        cell.configureView(word: self.words[indexPath.row])
        cell.updateSize()
        cell.action = {
            let vc = ArchiveTutorialViewController(word: self.words[indexPath.row])
            self.present(vc, animated: true, completion: nil)
        }
        return cell
    }
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}
