//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import Foundation

class PlacesViewModel {
    
    let model: DataManager = DataManager.shared
    
    var delegate:Refresh? {
        get {
            return model.delegate
        }
        set (value) {
            model.delegate = value
        }
    }
    
    init() {}
    
    // MARK: - Calculated Properties
    var places:[Place] {
        return model.places
    }
    
    var selectedIndex:Int {
        return model.selectedIndex
    }
    
    // MARK: - Functions
    
    func setSelectedIndex(to index:Int) {
        model.setSelectedIndex(to: index)
    }
    
    func addPlace(withName name:String, latitude:Double, longitude:Double) {
        let newIndex = model.addPlace(withName: name, latitude: latitude, longitude: longitude)
        model.reloadWeatherFromAPI(forPlaceIndex: newIndex)
        model.reloadWeatherHistoryFromAPI(forPlaceIndex: newIndex)
    }
    
    func renamePlace(atIndex index:Int, withNewName newName:String) {
        model.renamePlace(atIndex: index, withNewName: newName)
    }
    
    func deletePlace(atIndex index:Int) {
        model.deletePlace(atIndex: index)
    }
    
}

