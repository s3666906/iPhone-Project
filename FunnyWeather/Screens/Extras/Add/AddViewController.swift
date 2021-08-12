//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    var viewModel = AddViewModel()
    
    // MARK: - Outlets
    
    @IBAction func CancelButton(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: false, completion: nil)
    }
    @IBOutlet weak var CancelButtonHandle: UIBarButtonItem!
    @IBOutlet weak var MessageLabel: UILabel!
    @IBOutlet weak var AuthLocationServicesButton: UIButton!
    @IBOutlet weak var PlaceOnTheMap: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.places.count == 0 {
            CancelButtonHandle.isEnabled = false
            CancelButtonHandle.tintColor = UIColor.clear
            MessageLabel.text = "There are no saved places.  Where would you like to look?"
        } else {
            CancelButtonHandle.isEnabled = true
            CancelButtonHandle.tintColor = UIColor.appNavBarTint
            MessageLabel.text = "Where would you like to look?"
        }
    }
    
    // MARK: - Functions
    
    func configure() {
        navigationController?.navigationBar.tintColor = UIColor.appNavBarTint
        self.AuthLocationServicesButton.backgroundColor = UIColor.appButton
        self.PlaceOnTheMap.backgroundColor = UIColor.appButton
    }
}
