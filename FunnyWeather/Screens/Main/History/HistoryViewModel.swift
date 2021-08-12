//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewModel {
    
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
    
    func getHistoryChart(forIndex index:Int, size:CGSize) -> UIImage? {
        
        // Get the data
        var TemperatureRanges:[ChartImageTemperatureRange] = []
        let count = places[index].history?.count ?? 0
        for i in 0 ..< count {
            let dt = Int((places[index].history!.allObjects[i] as! History).dt)
            let max = (places[index].history!.allObjects[i] as! History).maxTemp
            let min = (places[index].history!.allObjects[i] as! History).minTemp
            TemperatureRanges.append(ChartImageTemperatureRange(dt: dt,
                                                                highValueInCelsius: max,
                                                                lowValueInCelsius: min))
        }
        
        // Get the image
        let chart:UIImage? = buildChartImage(forIndex: index,
                                             withSize: size,
                                             withData: TemperatureRanges,
                                             currentTemp: places[selectedIndex].weather!.temp,
                                             direction: .history)
        return chart
    }
}

