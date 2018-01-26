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
        case profile, about, icon, garmin
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
        navigationItem.title = "hideout".uppercased()
        contentView.versionLabel.text = applicationVersionString()
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
        let staticCells: [ViewModel.TableData] = [.profile, .about, .icon, .garmin]

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
        case .about:
            let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "detail-cell", for: indexPath) as! DetailCell
            cell.titleLabel.text = "NBRO".uppercased()
            cell.detailLabel.text = "What is it all about?"
            cell.iconImageView.image = #imageLiteral(resourceName: "info")
            cell.bottomSeparatorView.isHidden = true
            
            return cell
        case .icon:
            let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "detail-cell", for: indexPath) as! DetailCell
            cell.titleLabel.text = "App Icon"
            cell.detailLabel.text = "Alternates icons available"
            cell.iconImageView.image = #imageLiteral(resourceName: "alt-icon")
            cell.bottomSeparatorView.isHidden = true
            return cell
        case .garmin:
            let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "detail-cell", for: indexPath) as! DetailCell
            cell.titleLabel.text = "Garmin Watch Face"
            cell.detailLabel.text = "Get that sweet NBRO watch face"
            cell.iconImageView.image = #imageLiteral(resourceName: "garmin")
            return cell
        }

    }
    
    fileprivate func tableDataRow(_ indexPath: IndexPath) -> ViewModel.TableData {
        let type = ViewModel.TableData(rawValue: indexPath.row)!
        return type
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentView.tableView.deselectRow(at: indexPath, animated: true)
        let type = tableDataRow(indexPath)
        switch type {
        case .about:
            DispatchQueue.main.async { () -> Void in
                self.navigationController?.pushViewController(AboutViewController(), animated: true)
            }
        default: break;
        }
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
        self.navigationController?.isNavigationBarHidden = !authenticated

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

extension UserViewController {
    func applicationVersionString() -> String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
        
        return version + " (" + build + ")"
    }
}
