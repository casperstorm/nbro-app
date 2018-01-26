//
//  StickerViewController.swift
//  nbro
//
//  Created by Peter Gammelgaard Poulsen on 04/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import L360Confetti
import AVFoundation

class StickerViewController: UIViewController {
    private let stickerView: StickerContainerView
    let confettiView: L360ConfettiArea = {
        let confettiArea = L360ConfettiArea()
        confettiArea.swayLength = 20.0
        confettiArea.isUserInteractionEnabled = false
        confettiArea.blastSpread = 0.4
        return confettiArea
    }()
    let soundPlayer: AVAudioPlayer = {
        let soundURL = Bundle.main.url(forResource: "pop", withExtension: "aiff")
        let data = try? Data(contentsOf: soundURL!)
        let player = try! AVAudioPlayer(data: data!)
        player.prepareToPlay()
        
        return player
    }()
    
    let shareBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "share_navbar"), style: .plain, target: nil, action: nil)
    let loadingBarButtonItem: UIBarButtonItem
    
    init(image: UIImage) {
        stickerView = StickerContainerView(image: image)
        let loadingIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        loadingIndicatorView.startAnimating()
        loadingBarButtonItem = UIBarButtonItem(customView: loadingIndicatorView)
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
        
        confettiView.delegate = self
        UIApplication.shared.keyWindow?.addSubview(confettiView)
        confettiView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        stickerView.toolsView.button.addTarget(self, action: #selector(didTouchDownStickerButton), for: .touchDown)
        stickerView.toolsView.button.addTarget(self, action: #selector(didTouchUpInsideStickerButton), for: .touchUpInside)
        stickerView.toolsView.button.addTarget(self, action: #selector(didCancelStickerButton), for: .touchCancel)
        stickerView.toolsView.button.addTarget(self, action: #selector(didCancelStickerButton), for: .touchDragExit)
        
        shareBarButtonItem.action = #selector(sharePressed)
        shareBarButtonItem.target = self
        shareBarButtonItem.tintColor = .white
        navigationItem.rightBarButtonItem = shareBarButtonItem        
    }

    @objc dynamic private func didTouchDownStickerButton() {
        animateScaleTransform(view: stickerView.toolsView, sx: 0.85, 0.85)
    }
    
    @objc dynamic private func didTouchUpInsideStickerButton() {
        animateResetTransform(view: stickerView.toolsView)
        
        let stickerBrowserViewController = StickerBrowserViewController()
        stickerBrowserViewController.actionHandler = { [weak self] sticker in
            stickerBrowserViewController.dismiss(animated: true, completion: nil)
            self?.stickerView.add(sticker: sticker)
        }
        present(UINavigationController(rootViewController: stickerBrowserViewController), animated: true, completion: nil)
    }
    
    @objc dynamic private func didCancelStickerButton() {
        animateResetTransform(view: stickerView.toolsView)
    }
    
    @objc dynamic private func sharePressed() {
        let screenBounds = UIScreen.main.bounds
        navigationItem.rightBarButtonItem = loadingBarButtonItem
        let imageGenerator = ImageGenerator(image: stickerView.image, stickers: stickerView.stickers, scale: stickerView.scale)
        imageGenerator.generate { (image) in
            guard let image = image else { return }

            let delayTime = DispatchTime.now() + Double(Int64(0.10 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.soundPlayer.currentTime = 0
                self.soundPlayer.play()
                
                self.confettiView.blast(from: CGPoint(x: screenBounds.width/2, y: screenBounds.height - 420), towards: CGFloat(Double.pi/2), withForce: 400, confettiWidth: 8, numberOfConfetti: 35)
                self.confettiView.blast(from: CGPoint(x: screenBounds.width/2, y: screenBounds.height - 420), towards: CGFloat(Double.pi/2), withForce: 500, confettiWidth: 3, numberOfConfetti: 20)
            }

            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.present(activityViewController, animated: true) {
                self.navigationItem.rightBarButtonItem = self.shareBarButtonItem
            }
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

extension StickerViewController: L360ConfettiAreaDelegate {
    func colors(for confettiArea: L360ConfettiArea!) -> [Any]! {
        return [UIColor(hex: 0xFF5E5E), UIColor(hex: 0xFFD75E), UIColor(hex: 0x33DB96), UIColor(hex: 0xA97DBB), UIColor(hex: 0xCFCFCF), UIColor(hex: 0x2A7ADC)]
    }
}
