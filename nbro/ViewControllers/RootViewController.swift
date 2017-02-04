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
    enum ControllerType {
        case event, image, profile, about
        func associatedViewController() -> UIViewController {
            switch self {
            case .event:
                let vc = EventListViewController()
                vc.view.backgroundColor = .clear
                vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab_events").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab_events_selected").withRenderingMode(.alwaysOriginal))
                vc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
                return vc
            case .about:
                let vc = AboutViewController()
                vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab_about").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab_about_selected").withRenderingMode(.alwaysOriginal))
                vc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
                return vc
            case .image:
                let vc = UIViewController()
                vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab_image").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab_image_selected").withRenderingMode(.alwaysOriginal))
                vc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
                return vc
            case .profile:
                let vc = UserViewController()
                vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "icon_mask").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "icon_mask").withRenderingMode(.alwaysOriginal))
                vc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
                return vc
            }
        }
    }
    
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
        
        let viewControllers: [ControllerType] = [.event, .image, .profile, .about]
        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        tabBarController.tabBar.isTranslucent = false
        tabBarController.viewControllers = viewControllers.map { return UINavigationController(rootViewController: $0.associatedViewController()) }

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
