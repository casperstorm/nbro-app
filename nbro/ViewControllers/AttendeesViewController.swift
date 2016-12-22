//
//  AttendeesViewController.swift
//  nbro
//
//  Created by Casper Storm Larsen on 17/08/16.
//  Copyright © 2016 Bob. All rights reserved.
//

import Foundation
import UIKit
import Nuke

public enum State {
    case attendees
    case interested
}

class AttendeesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var contentView = AttendeesView()
    let event: Event
    let state: State
    let interactor = Interactor()
    var attendees: [FacebookProfile] = []
    
    
    init(event: Event, state: State) {
        self.event = event
        self.state = state
    
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        self.contentView.tableView.isHidden = true
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TrackingManager.trackEvent(.viewAttendees)
    }
    
    func setupSubviews() {
        contentView.cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
        
        switch(state) {
            case .attendees:
                self.contentView.titleLabel.text = "Attending".uppercased()
            case .interested:
                self.contentView.titleLabel.text = "Interested".uppercased()
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Data
    
    fileprivate func loadData() {
        if state == .attendees {
            FacebookManager.attendeesForEvent(event) { (result) in
                guard let dict = result["attending"], let dataArray = dict["data"] as? [NSDictionary] else { return }
                self.handleData(dataArray)
            }
        } else if state == .interested {
            FacebookManager.interestedForEvent(event) { (result) in
                guard let dict = result["maybe"], let dataArray = dict["data"] as? [NSDictionary] else { return }
                self.handleData(dataArray)
            }
        }
    }
    
    fileprivate func handleData(_ result: [NSDictionary]) {
        self.attendees = result.map({ (data) -> FacebookProfile in
            return FacebookProfile(dictionary: data)!
        })
        self.contentView.tableView.isHidden = false
        self.fadeoutLoadingIndicator()
        self.contentView.tableView.reloadData()
        self.animateCellsEntrance(true)
    }
    
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "attendee-cell", for: indexPath) as! AttendeeCell
        let attendee = attendees[indexPath.row]
        cell.titleLabel .text = attendee.name
        cell.profileImageView.image = nil
        
        let request = ImageRequest(URLRequest: URLRequest(URL: attendee.imageURL))
        Nuke.taskWith(request) { response in
            switch response {
            case let .Success(image, _):
                cell.profileImageView.image = image.convertToGrayScale()
            case .Failure(_): break
            }
            }.resume()
        
        
        if(indexPath.row < attendees.count - 1) {
            cell.bottomSeparatorView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let attendee = attendees[indexPath.row]
        UIApplication.shared.openURL(URL(string: "https://www.facebook.com/\(attendee.id)/")!)
    }
    
    //MARK: Actions
    
    func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Helpers
    
    fileprivate func fadeoutLoadingIndicator() {
        UIView.animate(withDuration: 0.5, animations: {
            self.contentView.loadingView.activityIndicatorView.alpha = 0.0
            }, completion: { (completed) in
                self.contentView.loadingView.activityIndicatorView.stopAnimating()
                self.contentView.loadingView.activityIndicatorView.alpha = 1.0
        })
    }
    
    fileprivate func animateCellsEntrance(_ animate: Bool) {
        if(animate) {
            let visibleCells = contentView.tableView.visibleCells
            for index in 0 ..< visibleCells.count {
                let delay = (Double(index) * 0.04) + 0.3
                let cell = visibleCells[index]
                cell.transform = CGAffineTransform(translationX: UIScreen.main.bounds.size.width - 120.0, y: 0)
                cell.alpha = 0
                UIView.animate(withDuration: 0.9, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform.identity
                    cell.alpha = 1.0
                    }, completion: nil)
            }
        }
    }
    
}
