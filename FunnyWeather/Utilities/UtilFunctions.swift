//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import Foundation
import UIKit

// Convert the temperature stored in the model in degrees
// celsius, into the units selected by the user and append
// the corresponding symbol to the end
func convertToUserUnits(celsiusValue:Double?) -> String? {
    
    guard let celsiusValue = celsiusValue else { return "?" }
    
    let toUnits:String = UserDefaults.standard.string(forKey: "user_temperature_units") ?? "C"
    
    var toValue:Double = celsiusValue
    switch toUnits {
    case "C":
        toValue = celsiusValue
    case "F":
        toValue = celsiusValue * 9.0 / 5.0 + 32.0
    case "K":
        toValue = celsiusValue + 273.15
    case "R":
        toValue = (celsiusValue + 273.15) * 9.0 / 5.0
    case "De":
        toValue = (100 - celsiusValue) * 3.0 / 2.0
    case "N":
        toValue = celsiusValue * 33.0 / 100.0
    case "Ré":
        toValue = celsiusValue * 4.0 / 5.0
    case "Rø":
        toValue = celsiusValue * 21.0 / 40.0 + 7.5
    default:
        toValue = celsiusValue
    }
    return "\(String(format: "%.0f", toValue))°\(toUnits)"
}

func switchToTheSettingsApp() {
    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
    if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl, completionHandler: nil)
    }
}
