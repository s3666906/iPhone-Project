//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import Foundation

class AddViewModel {
    
    let model: DataManager = DataManager.shared
    
    init() {}
    
    // MARK: - Calculated Properties
    var places:[Place] {
        return model.places
    }
    
    var selectedIndex:Int {
        return model.selectedIndex
    }
    
    // MARK: - Functions
    
    func FindNearbyWebcamsFromAPI(latitude:Double, longitude:Double) -> [String] {
        return model.FindNearbyWebcamsFromAPI(latitude: latitude, longitude: longitude)
    }
    
    func addPlace(withName name:String, latitude:Double, longitude:Double, webcamURL:String) {
        
        let newIndex = model.addPlaceWithWebcamURL(withName: name, latitude: latitude, longitude: longitude, webcamURL: webcamURL)
        model.reloadWeatherFromAPI(forPlaceIndex: newIndex)
        model.reloadWeatherHistoryFromAPI(forPlaceIndex: newIndex)
    }
    
}

