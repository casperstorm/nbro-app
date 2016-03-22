//
//  UserViewController.swift
//  nbro
//
//  Created by Casper Storm Larsen on 22/03/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation


class UserViewController: UIViewController {
    var contentView = UserView()
    var interactor:Interactor?
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        
        FacebookManager.user { (user) in
            print(user)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.trackEvent(.ViewUser)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func setupSubviews() {
        contentView.cancelButton.addTarget(self, action: #selector(cancelPressed), forControlEvents: .TouchUpInside)
    }
    
    //MARK: Actions
    
    func cancelPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}