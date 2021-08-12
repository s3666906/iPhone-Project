//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

// Structure of the webcam api response
struct Windy:Codable {
    var result:WindyResult
}

struct WindyResult:Codable {
    var webcams:[WindyWebcam]
}

struct WindyWebcam:Codable {
    var id:String
    var title:String
    var image:WindyImage
}

struct WindyImage:Codable {
    var current:WindyFileURL
    var daylight:WindyFileURL
}

struct WindyFileURL:Codable {
    var thumbnail:String
    var preview:String
}
