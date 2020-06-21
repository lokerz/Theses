//
//  BaseViewController.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 15/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit

enum Menu : String {
    case Single = "singleplayer"
    case Multi = "multiplayer"
    case Archive = "archive"
}

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackground()
    }
    
    func setupBackground(){
        let bg = UIImageView(image: UIImage(named: "main_bg"))
        bg.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bg)
        self.view.sendSubviewToBack(bg)
        
        NSLayoutConstraint.activate([
            bg.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            bg.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            bg.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            bg.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        ])
    }
    
    func setupTitle(title: Menu){
        let header = UIImageView(image: UIImage(named: title.rawValue))
        header.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(header)
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            header.centerXAnchor.constraint(equalTo: margins.centerXAnchor, constant: 0),
            header.topAnchor.constraint(equalTo: margins.topAnchor, constant: 8),
            header.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    func setupBackButton(){
        let frame = CGRect(x: 0, y: 0, width: 70, height: 72)
        let img = UIImage(named: "button_back")
        let button = UIButton(frame: frame)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(img, for: .normal)
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        button.addTarget(self, action: #selector(haptic), for: .touchDown)
        self.view.addSubview(button)
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0),
            button.topAnchor.constraint(equalTo: margins.topAnchor, constant: 8)
        ])
    }
    
    @objc func dismissAction(){
        SoundManager.shared.play()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func haptic(){
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
