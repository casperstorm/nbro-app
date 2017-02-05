//
//  StickerViewController.swift
//  nbro
//
//  Created by Peter Gammelgaard Poulsen on 04/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation

class StickerViewController: UIViewController {
    private let stickerView: StickerContainerView
    
    init(image: UIImage) {
        stickerView = StickerContainerView(image: image)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(stickerView)
        stickerView.snp.makeConstraints { (make) in
            make.edges.equalTo(stickerView.superview!)
        }
        
        let addBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addStickerPressed))
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    dynamic private func addStickerPressed() {
        let stickerBrowserViewController = StickerBrowserViewController()
        stickerBrowserViewController.actionHandler = { [weak self] image in
            stickerBrowserViewController.dismiss(animated: true, completion: nil)
            self?.stickerView.add(image: image)
        }
        present(UINavigationController(rootViewController: stickerBrowserViewController), animated: true, completion: nil)
    }
}
