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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitle(title: .Archive)
        self.setupBackButton()
        self.setupTableView()
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
}

extension ArchiveViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WordManager.instance.words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! ArchiveTableViewCell
        let word = WordManager.instance.words[indexPath.row]
        cell.configureView(word: word.data)
        cell.action = {
            let vc = ArchiveTutorialViewController(word: word.data)
            self.present(vc, animated: true, completion: nil)
        }
        //        cell.progress = word.progress
        return cell
    }
    
    
}
