//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

struct icanhazdadjoke:Codable {
    var results:[icanhazdadjokeResult]
}

struct icanhazdadjokeResult:Codable {
    var joke:String
}
