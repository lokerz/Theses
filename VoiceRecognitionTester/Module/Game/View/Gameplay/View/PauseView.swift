//
//  PauseViewController.swift
//  VoiceRecognitionTester
//
//  Created by koinworks on 17/06/20.
//  Copyright © 2020 ridwan. All rights reserved.
//

import UIKit

class PauseView: UIView {

    @IBOutlet weak var contentView: UIView!
    
    var yes_method : (() -> Void)?
    var no_method : (() -> Void)?
    
    @IBOutlet weak var lblText: UILabel!
    
    override func awakeFromNib() {
        self.initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initView()
    }
    
    private func initView(){
        Bundle.main.loadNibNamed("PauseView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBAction func actionYes(_ sender: Any) {
        yes_method?()
    }
    @IBAction func actionNo(_ sender: Any) {
        no_method?()
    }
    
}
