//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import Foundation
import UIKit

class ForecastViewModel {
    
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
    
    func getForecastChart(forIndex index:Int, size:CGSize) -> UIImage? {
        
        // Get the data
        var TemperatureRanges:[ChartImageTemperatureRange] = []
        
        let count = places[index].forecast?.count ?? 0
        for i in 0 ..< count {
            let dt = Int((places[index].forecast!.allObjects[i] as! Forecast).dt)
            let max = (places[index].forecast!.allObjects[i] as! Forecast).maxTemp
            let min = (places[index].forecast!.allObjects[i] as! Forecast).minTemp
            TemperatureRanges.append(ChartImageTemperatureRange(dt: dt,
                                                                highValueInCelsius: max,
                                                                lowValueInCelsius: min))
        }
        
        // Get the image
        let chart:UIImage? = buildChartImage(forIndex: index,
                                             withSize: size,
                                             withData: TemperatureRanges,
                                             currentTemp: places[selectedIndex].weather!.temp,
                                             direction: .forecast)
        return chart
    }
}

