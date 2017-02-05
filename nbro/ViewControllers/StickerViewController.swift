//
//  StickerViewController.swift
//  nbro
//
//  Created by Peter Gammelgaard Poulsen on 04/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation

class StickerViewController: UIViewController {
    private let stickerView = StickerContainerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(stickerView)
        stickerView.snp.makeConstraints { (make) in
            make.edges.equalTo(stickerView.superview!)
        }
        
        DispatchQueue.main.async {
            self.stickerView.setupTestData()
        }
    }
}
