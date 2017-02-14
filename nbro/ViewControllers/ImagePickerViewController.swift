//
//  ImagePickerViewController.swift
//  nbro
//
//  Created by Casper Storm Larsen on 05/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerViewController: UIViewController {
    var contentView = ImagePickerView()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
}

extension ImagePickerViewController {
    fileprivate func setupSubviews() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Add image".uppercased()
        
        contentView.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
}

extension ImagePickerViewController {
    func buttonPressed() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(pickerController, animated: true, completion: nil)
        
    }
}

extension ImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let stickerViewController = StickerViewController(image: image)
            navigationController?.pushViewController(stickerViewController, animated: true)
        }

        self.dismiss(animated: true, completion: nil)
    }
    
}
