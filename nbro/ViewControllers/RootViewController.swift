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
        
        let eventListViewController = EventListViewController()
        let enc = UINavigationController(rootViewController: eventListViewController)
        enc.view.backgroundColor = .clear
        enc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab_events").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab_events").withRenderingMode(.alwaysOriginal))
        enc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        
        let profileViewController = UserViewController()
        let pnc = UINavigationController(rootViewController: profileViewController)
        pnc.view.backgroundColor = .clear
        pnc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "icon_mask").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "icon_mask").withRenderingMode(.alwaysOriginal))
        pnc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        
        let aboutViewController = AboutViewController()
        let anc = UINavigationController(rootViewController: aboutViewController)
        anc.view.backgroundColor = .clear
        anc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab_about").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab_about").withRenderingMode(.alwaysOriginal))
        anc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        
        let imageViewController = UIViewController()
        let inc = UINavigationController(rootViewController: imageViewController)
        inc.view.backgroundColor = .clear
        inc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab_image").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab_image").withRenderingMode(.alwaysOriginal))
        inc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        tabBarController.tabBar.isTranslucent = false
        tabBarController.viewControllers = [
            enc,
            inc,
            pnc,
            anc
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
