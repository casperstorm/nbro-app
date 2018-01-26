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
        case event, image, profile
        func associatedViewController() -> UIViewController {
            switch self {
            case .event:
                let vc = EventListViewController()
                vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab_events").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab_events_selected").withRenderingMode(.alwaysOriginal))
                vc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
                return vc
            case .image:
                let vc = ImagePickerViewController()
                vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab_image").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab_image_selected").withRenderingMode(.alwaysOriginal))
                vc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
                return vc
            case .profile:
                let vc = UserViewController()
                vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab_profile").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab_profile_selected").withRenderingMode(.alwaysOriginal))
                vc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
                return vc
            }
        }
    }
    
    private var contentController: UIViewController?
    private let tabBarViewController = UITabBarController(nibName: nil, bundle: nil)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let selectedViewController = tabBarViewController.selectedViewController else { return super.preferredStatusBarStyle }
        guard let child = selectedViewController.childViewControllers.first else { return selectedViewController.preferredStatusBarStyle }
        return child.preferredStatusBarStyle
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let viewControllers: [ControllerType] = [.event, .image, .profile]
        
        tabBarViewController.tabBar.isTranslucent = false
        tabBarViewController.viewControllers = viewControllers.map { return UINavigationController(rootViewController: $0.associatedViewController()) }
        
        showContentController(tabBarViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func showContentController(_ controller: UIViewController) {
        removeCurrentContentController()
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        contentController = controller
        controller.view.frame = view.bounds
    }
    
    fileprivate func removeCurrentContentController() {
        contentController?.willMove(toParentViewController: nil)
        contentController?.view.removeFromSuperview()
        contentController?.removeFromParentViewController()
        contentController = nil
    }
}
