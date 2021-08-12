//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    let model: DataManager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.requestNewJokesfromAPI()
        model.loadFromCoreData()
    }
    
}
