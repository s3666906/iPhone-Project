//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import Foundation

class TodayViewModel {
    
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
    
    func selectNextIndex() {
        model.selectNextIndex()
    }
    
    func selectPreviousIndex() {
        model.selectPreviousIndex()
    }
}

