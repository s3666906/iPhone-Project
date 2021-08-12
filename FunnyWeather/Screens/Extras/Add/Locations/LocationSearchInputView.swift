//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "SearchCell"

protocol SearchInputViewDelegate {
    func animateCenterMapButton(expansionState: LocationSearchInputView.ExpansionStates, hideButton: Bool)
}

class LocationSearchInputView: UIView {
    
    var indicatorView: UIView!
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var expansionState: ExpansionStates!
    var delegate: SearchInputViewDelegate?
    enum ExpansionStates {
        case NotExpanded
        case PartiallyExpanded
        case FullyExpanded
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
    
        expansionState = .NotExpanded
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func HandleSwipeGesture(sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            
            if expansionState == .NotExpanded {
                self.delegate?.animateCenterMapButton(expansionState: self.expansionState, hideButton: false)
                animateInputView(targetPosition: self.frame.origin.y - 250) { (_) in
                    self.expansionState = .PartiallyExpanded
                }
            }
            
            if expansionState == .PartiallyExpanded {
                self.delegate?.animateCenterMapButton(expansionState: self.expansionState, hideButton: true)
                animateInputView(targetPosition: self.frame.origin.y - 400) { (_) in
                    self.expansionState = .FullyExpanded
                }
            }
            
        } else {
            // swipe down
            
            if expansionState == .FullyExpanded {
                self.searchBar.endEditing(true)
                self.searchBar.showsCancelButton = false
                animateInputView(targetPosition: self.frame.origin.y + 400) { (_) in
                    self.delegate?.animateCenterMapButton(expansionState: self.expansionState, hideButton: false)
                    self.expansionState = .PartiallyExpanded
                }
            }

            if expansionState == .PartiallyExpanded {
                delegate?.animateCenterMapButton(expansionState: self.expansionState, hideButton: false)
                animateInputView(targetPosition: self.frame.origin.y + 250) { (_) in
                    self.expansionState = .NotExpanded
                }
            }
        }
    }
    
    func animateInputView(targetPosition: CGFloat, completion: @escaping(Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.frame.origin.y = targetPosition
            }, completion: completion)
    }
    func configureViewComponents() {
        backgroundColor = .white
        
        configureIndicatorView()
        configureSearchBar()
        configureTableView()
        configureGestureRecognizers()
    }
    
    func configureIndicatorView() {
        indicatorView = UIView()
        indicatorView.backgroundColor = .lightGray
        indicatorView.layer.cornerRadius = 5
        indicatorView.alpha = 0.8
        
        addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 8).isActive = true
        indicatorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search for a place or Postcode"
        searchBar.delegate = self
        searchBar.barStyle = .black
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 4).isActive = true
        searchBar.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        searchBar.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func configureTableView() {
        tableView = UITableView()
        tableView.rowHeight = 72
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LocationSearchCell.self, forCellReuseIdentifier: "SearchCell")
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 100).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
    }
    
    func configureGestureRecognizers() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(HandleSwipeGesture))
        swipeUp.direction = .up
        addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(HandleSwipeGesture))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
}

extension LocationSearchInputView: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if expansionState == .NotExpanded {
            animateInputView(targetPosition: self.frame.origin.y - 650) { (_) in
                self.expansionState = .FullyExpanded
            }
        }
        if expansionState == .PartiallyExpanded {
            animateInputView(targetPosition: self.frame.origin.y - 400) { (_) in
                self.expansionState = .FullyExpanded
            }
        }
        self.delegate?.animateCenterMapButton(expansionState: self.expansionState, hideButton: true)
        searchBar.showsCancelButton =  true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton =  false
        searchBar.endEditing(true)
        if expansionState == .FullyExpanded {
            animateInputView(targetPosition: self.frame.origin.y + 400) { (_) in
                self.delegate?.animateCenterMapButton(expansionState: self.expansionState, hideButton: false)
                self.expansionState = .PartiallyExpanded
            }
        }
    }
    
}

extension LocationSearchInputView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationSearchCell
        return cell
    }
}


