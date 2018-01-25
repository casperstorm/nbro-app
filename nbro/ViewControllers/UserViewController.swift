//
//  UserViewController.swift
//  nbro
//
//  Created by Casper Storm Larsen on 22/03/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import Nuke

fileprivate class ViewModel {
    enum TableData: Int {
        case profile, information, event
    }
    
    var user: FacebookProfile?
    func loadUser(_ completion: @escaping (_ user: FacebookProfile?) -> Void) {
        FacebookManager.user(completion)
    }
}

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate let viewModel = ViewModel()
    var contentView = UserView()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.trackEvent(.viewUser)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareToLoadData()
    }

    func setupSubviews() {        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        
        contentView.notAuthenticatedView.titleLabel.text = "go to login".uppercased()
        contentView.notAuthenticatedView.descriptionLabel.text = "In order to see your user, you need to login."
        contentView.notAuthenticatedView.button.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let staticCells: [ViewModel.TableData] = [.profile, .information]

        return staticCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableDataRow(indexPath) {
        case .profile:
            let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "user-cell", for: indexPath) as! UserProfileCell
            if let user = viewModel.user {
                cell.userNameLabel.text = user.name.uppercased()
                Manager.shared.loadImage(with: user.imageURL, token: nil) { result in
                    switch result {
                    case .success(let image):
                        cell.userImageView.image = image.convertToGrayScale()
                    case .failure(let error):
                        print("Oh noes. Image could not be loaded: \(error.localizedDescription)")
                    }
                }
            }
            return cell
        case .information:
            let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "text-cell", for: indexPath) as! UserTextCell
            cell.bodyLabel.text = "It looks like you don't have any upcoming events. Remember, your commitment will be rewarded mile by mile."

            return cell
        case .event:
            let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "event-cell", for: indexPath) as! UserEventCell
            return cell
        }

    }
    
    fileprivate func tableDataRow(_ indexPath: IndexPath) -> ViewModel.TableData {
        if(indexPath.row == 0) {
            return .profile
        } else if (indexPath.row == 1) {
            return .information
        } else {
            return .event
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentView.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserViewController {
    @objc dynamic fileprivate func loginPressed() {
        let loginViewController = LoginViewController()
        present(loginViewController, animated: true) { () -> Void in
        }
    }
    
    @objc dynamic fileprivate func logoutPressed() {
        let alertController = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Log out", style: .default, handler: { (_) -> Void in
            TrackingManager.trackEvent(.logout)
            FacebookManager.logout()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.skipLogin(false)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) -> Void in
        }))
        
        present(alertController, animated: true, completion: nil)
    }
}

extension UserViewController {
    func prepareToLoadData() {
        let authenticated = FacebookManager.authenticated()
        if (authenticated) {
            
            contentView.notAuthenticatedView.isHidden = true
            
            let logoutBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "logout"), style: .plain, target: self, action: #selector(logoutPressed))
            navigationItem.rightBarButtonItem = logoutBarButtonItem
            
            if(viewModel.user == nil) {
                contentView.tableView.isHidden = true
                loadData()
            } else {
                contentView.tableView.isHidden = false
            }
        } else {
            contentView.notAuthenticatedView.isHidden = false
            contentView.tableView.isHidden = true
            navigationItem.rightBarButtonItem = nil
            
        }
    }
    
    func loadData() {
        viewModel.loadUser({ user in
            self.viewModel.user = user
            
            self.contentView.tableView.alpha = 0.0
            self.contentView.tableView.isHidden = false
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.contentView.tableView.alpha = 1.0
            })
            
            self.contentView.tableView.reloadData()
        })
    }
    
}
