//
//  RootViewController.swift
//  nbro
//
//  Created by Peter Gammelgaard Poulsen on 04/02/2017.
//  Copyright © 2017 Bob. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UIViewController {
    private var contentController: UIViewController?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        tabBarController.tabBar.isTranslucent = false
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: EventListViewController()),
            UINavigationController(rootViewController: UserViewController()),
            UINavigationController(rootViewController: AboutViewController())
        ]
        
        showContentController(tabBarController)
    }
    
    private func showContentController(_ controller: UIViewController) {
        removeCurrentContentController()
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        contentController = controller
    }
    
    fileprivate func removeCurrentContentController() {
        contentController?.willMove(toParentViewController: nil)
        contentController?.view.removeFromSuperview()
        contentController?.removeFromParentViewController()
        contentController = nil
    }
}
