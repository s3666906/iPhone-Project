//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import Foundation

class JokeViewModel {
    
    let model: DataManager = DataManager.shared
    
    init() {}
    
    // MARK: - Calculated Properties
    var places:[Place] {
        return model.places
    }
    
    func getJoke() -> String {
        return model.getJoke()
    }
}

