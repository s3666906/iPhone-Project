//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import Foundation


// Today and Forecast data
struct OWMTodayAndForecast:Codable {
    var current:OWMCurrent
    var daily:[OWMDaily]
}

struct OWMCurrent:Codable {
    var temp:Double
    var weather:[OWMCurrentWeather]
}

struct OWMCurrentWeather:Codable {
    var main:String
    var description:String
    var icon:String
}

struct OWMDaily:Codable {
    var dt:Int
    var temp:OWMDailyTemp
}

struct OWMDailyTemp:Codable {
    var min:Double
    var max:Double
}


// Historic data
// Historic weather (1 call for each day of data)

struct OWMHistory:Codable {
    var current:OWMHistoryCurrent
    // We get the hourly records and calculate the min/max for the day
    var hourly:[OWMHistoryHourly]
}

struct OWMHistoryCurrent:Codable {
    var dt:Int
    var temp:Double
}

struct OWMHistoryHourly:Codable {
    var temp:Double
}

