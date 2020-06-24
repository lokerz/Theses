//
//  SinglePlayerViewController.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 15/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit
import ARKit

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
        self.collectionView.isHidden = true
    }

    func updateCellSize(){
        self.collectionView.reloadData()
        self.collectionView.isHidden = false
    }
}

extension SinglePlayerViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LevelManager.shared.TOTAL_LEVEL
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
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                self.openLevel(authorized: true, level: level)
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.openLevel(authorized: true, level: level)
                    } else {
                        self.openLevel(authorized: false, level: level)
                    }
                }
                
            case .denied, .restricted: // The user has previously denied access.
                self.openLevel(authorized: false, level: level)
                return
                
            @unknown default :
                self.openLevel(authorized: false, level: level)
                return
            }
        }
        
        cell.prepareForReuse()
        return cell
    }
    
    func openLevel(authorized: Bool, level: Int){
        SoundManager.shared.play()
        DispatchQueue.main.async {
            if ARConfiguration.isSupported && authorized{
                let vc = GameplayViewController(level: level)
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = NonARGameplayViewController(level: level)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
}
