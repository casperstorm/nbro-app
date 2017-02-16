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
        
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        
        title = "EDIT"
        
        view.addSubview(stickerView)
        stickerView.snp.makeConstraints { (make) in
            make.edges.equalTo(stickerView.superview!)
        }
        
        stickerView.toolsView.button.addTarget(self, action: #selector(didTouchDownStickerButton), for: .touchDown)
        stickerView.toolsView.button.addTarget(self, action: #selector(didTouchUpInsideStickerButton), for: .touchUpInside)
        stickerView.toolsView.button.addTarget(self, action: #selector(didCancelStickerButton), for: .touchCancel)
        stickerView.toolsView.button.addTarget(self, action: #selector(didCancelStickerButton), for: .touchDragExit)
        
        
        let shareBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "share_navbar"), style: .plain, target: self, action: #selector(sharePressed))
        shareBarButtonItem.tintColor = .white
        navigationItem.rightBarButtonItem = shareBarButtonItem        
    }

    dynamic private func didTouchDownStickerButton() {
        animateScaleTransform(view: stickerView.toolsView, sx: 0.85, 0.85)
    }
    
    dynamic private func didTouchUpInsideStickerButton() {
        animateResetTransform(view: stickerView.toolsView)
        
        let stickerBrowserViewController = StickerBrowserViewController()
        stickerBrowserViewController.actionHandler = { [weak self] image in
            stickerBrowserViewController.dismiss(animated: true, completion: nil)
            self?.stickerView.add(image: image)
        }
        present(UINavigationController(rootViewController: stickerBrowserViewController), animated: true, completion: nil)
    }
    
    dynamic private func didCancelStickerButton() {
        animateResetTransform(view: stickerView.toolsView)
    }
    
    dynamic private func sharePressed() {
        let imageGenerator = ImageGenerator(image: stickerView.image, stickers: stickerView.stickers, scale: stickerView.scale)
        imageGenerator.generate { (image) in
            guard let image = image else { return }
            
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}

extension StickerViewController {
    fileprivate func animateScaleTransform(view: UIView, sx: CGFloat, _ sy: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            view.transform = view.transform.scaledBy(x: sx, y: sy)
        }
    }
    
    fileprivate func animateResetTransform(view: UIView) {
        UIView.animate(withDuration: 0.1) {
            view.transform = CGAffineTransform.identity
        }
    }
}
