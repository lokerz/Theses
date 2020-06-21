//
//  SinglePlayerViewController.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 15/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit

class SinglePlayerViewController: BaseViewController {

    let cellID = "SinglePlayerCollectionViewCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitle(title: .Single)
        self.setupBackButton()
        self.setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateCellSize()
    }
    
    func setupCollectionView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
    }

    func updateCellSize(){
        self.collectionView.reloadData()
    }
}

extension SinglePlayerViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LevelManager.shared.lock_status.last == false ? LevelManager.shared.TOTAL_LEVEL - 1 : LevelManager.shared.TOTAL_LEVEL
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width / 2 - 10
        let height = 7 * width / 16
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SinglePlayerCollectionViewCell
        let level = indexPath.row + 1
        cell.configureView(level: level)
        cell.updateSize()
        cell.btnLevel.isEnabled = LevelManager.shared.lock_status[indexPath.row]
        cell.action = {
            SoundManager.shared.play()
            let vc = GameplayViewController(level: level)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.prepareForReuse()
        return cell
    }
    
    
}
