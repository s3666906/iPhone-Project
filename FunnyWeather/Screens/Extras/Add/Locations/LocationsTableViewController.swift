//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import UIKit

class LocationsTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hiding the tabbar while editing the locations list means the user MUST stop editing before they can change tabs
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 //data.locationCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let rename = UIContextualAction(style: .normal, title: "Rename") { (UIContextualAction, view, actionPerformed: @escaping (Bool) -> ()) in
            
            let alertController = UIAlertController(title: "Rename Location", message: "Enter a new name for the location ", preferredStyle: .alert)
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "New Name"
            }
            
            let renameAction = UIAlertAction(title: "Rename", style: .default, handler: { alert -> Void in
                // save the new name
                actionPerformed(true)
                self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { alert -> Void in
                // cancel the rename
                actionPerformed(false)
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(renameAction)

            self.present(alertController, animated: true, completion: nil)
        }
        rename.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return UISwipeActionsConfiguration(actions: [rename])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (UIContextualAction, view, actionPerformed: @escaping (Bool) -> ()) in
            
            let alert = UIAlertController(title: "Delete Location", message: "Are you sure you want to delete ", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
                actionPerformed(false)
            }))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alertAction) in
                actionPerformed(true)
            }))
            
            self.present(alert, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    

}
