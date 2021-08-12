//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import UIKit

class PlacesViewController: UITableViewController, Refresh {
    
    func updateUI() {
        PlacesTableView.reloadData()
    }
    
    
    var viewModel = PlacesViewModel()
    
    // MARK: - Outlets
    @IBAction func ToSettingsAppButton(_ sender: UIBarButtonItem) {
        switchToTheSettingsApp()
    }
    
    @IBAction func AddButton(_ sender: UIBarButtonItem) {
        addButtonPressed()
    }
    
    @IBOutlet var PlacesTableView: UITableView!
    
    // MARK: - Functions - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        monitorReturningFromTheSettingsApp()
        viewModel.delegate = self
        navigationController?.navigationBar.tintColor = UIColor.appNavBarTint
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Returning to the Places screen always resets the selected place
        viewModel.setSelectedIndex(to: 0)
        
        // Always check that there are places to show and if not then
        // send the user directly to the add screen
        forceUserToTheAddScreenIfNeeded()
    }

    func forceUserToTheAddScreenIfNeeded() {
        if viewModel.places.count == 0 {
            performSegue(withIdentifier: "ToAdd", sender: self)
        }
    }
    
    func monitorReturningFromTheSettingsApp() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(willEnterForeground),
            name: NSNotification.Name.UIApplicationWillEnterForeground,
            object: nil)
    }
    @objc func willEnterForeground() {
        PlacesTableView.reloadData()
    }
    
    // MARK: - Functions for User Interaction
    func addButtonPressed() {
        let alert = UIAlertController(title: "Add Place",
                                      message: "What is the place name?",
                                      preferredStyle: .alert)
        
        alert.addTextField()  // Name
        alert.addTextField()  // Latitude
        alert.addTextField()  // Longitude
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let name = alert.textFields![0].text!
            // Force unwrapping these next 2 fields since this is a temporary function
            let latitude = Double(alert.textFields![1].text!)!
            let longitude = Double(alert.textFields![2].text!)!
            
            self.viewModel.addPlace(withName: name, latitude: latitude, longitude: longitude)
            
        }
        
        alert.addAction(submitButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setSelectedIndex(to: indexPath.row)
        // Give focus to the Today tab
        tabBarController?.selectedIndex = 1
        
    }
    
    // Swip Left (Delete)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (UIContextualAction, view, actionPerformed: @escaping (Bool) -> ()) in
            
            let alert = UIAlertController(title: "Confirmation",
                                          message: "Are you sure you want to delete this saved place?",
                                          preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: .default) { (action) in
                // Do nothing
                actionPerformed(false)
          }
            let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                // Do the delete
                actionPerformed(true)
                self.viewModel.deletePlace(atIndex: indexPath.row)
                self.forceUserToTheAddScreenIfNeeded()
            }
            alert.addAction(cancelButton)
            alert.addAction(deleteButton)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        deleteAction.backgroundColor = UIColor.appSwipeDelete
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // Swipe Right (Rename)
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let renameAction = UIContextualAction(style: .normal, title: "Rename") {
            (UIContextualAction, view, actionPerformed: @escaping (Bool) -> ()) in
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .default) { (action) in
                // Do nothing
                actionPerformed(false)
            }
            
            let oldPlaceName = self.viewModel.places[indexPath.row].name!
            let alert = UIAlertController(title: "Rename",
                                          message: "What is the new name?",
                                          preferredStyle: .alert)
            alert.addTextField() // New Name
            let newPlaceNameField = alert.textFields![0]
            newPlaceNameField.text = oldPlaceName
            let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
                let newPlaceName = newPlaceNameField.text ?? oldPlaceName
                // Do the rename
                actionPerformed(true)
                self.viewModel.renamePlace(atIndex: indexPath.row, withNewName: newPlaceName)
            }
            alert.addAction(cancelButton)
            alert.addAction(saveButton)
            self.present(alert, animated: true, completion: nil)
            
        }
        renameAction.backgroundColor = UIColor.appSwipeRename
        return UISwipeActionsConfiguration(actions: [renameAction])
    }
}

// MARK: - Extensions

extension PlacesViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath) as! PlacesTableViewCell
        
        cell.Banner.backgroundColor = UIColor.appPlacesBanner
        
        let place = viewModel.places[indexPath.row]
        cell.PlaceName.text = place.name
        cell.PlaceTemp.text = ""
        cell.PlaceDesc.text = ""
        cell.PlaceIcon.image = nil
        if let weather = place.weather {
            cell.PlaceTemp.text = convertToUserUnits(celsiusValue: weather.temp)
            cell.PlaceDesc.text = weather.desc
            cell.PlaceIcon.image = UIImage(named: weather.icon ?? "unknown")
        }
        
        return cell
    }
    
}
