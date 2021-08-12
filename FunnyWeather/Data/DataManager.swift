//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol Refresh {
    func updateUI()
}

class DataManager {
    
    static var shared = DataManager()
    
    // Managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Stored Properties
    private var _places:[Place]?
    private (set) var selectedIndex:Int = 0 
    
    private var _jokes:[Joke]?

    var delegate:Refresh?
    
    private let session = URLSession.shared
    
    private init() {}
    
    // MARK: - Computed Properties
    var places:[Place] {
        get {
            return _places ?? []
        }
    }
    
    var jokes:[Joke] {
        get {
            return _jokes ?? []
        }
    }
    
    func loadFromCoreData() {
        
        // Get the list of places from Core Data
        _places = try? context.fetch(Place.fetchRequest())
        
        // For each place
        for index in 0 ..< places.count {
            reloadWeatherFromAPI(forPlaceIndex: index)
            reloadWeatherHistoryFromAPI(forPlaceIndex: index)
            //reloadWebcamImageFromAPI(forPlaceIndex: index)
        }
        
        // Get the list of jokes from Core Data
        _jokes = try? context.fetch(Joke.fetchRequest())

    }
    
    
    
    // MARK: - Functions
    func refreshUI() {
        saveContext()
        fetchPlaces()
        DispatchQueue.main.async {
            self.delegate?.updateUI()
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving data")
        }
    }
    
    func fetchPlaces() {
        do {
            // Get the data from Core Data
            self._places = try context.fetch(Place.fetchRequest())
        } catch {
            print("Error fetching places from core data")
        }
    }
    
    
    func setSelectedIndex(to index:Int) {
        // Make sure we don't set the index out of range
        if indexIsInRange(index) {
            selectedIndex = index
        } else {
            selectedIndex = 0
        }
    }
    
    func selectNextIndex() {
        /*
         If we just set the current index plus 1 we could send the index out of range.
         By modding it by the count of locations if forces the index to wrap back into range.
         
         eg. if there were 4 locations (0, 1, 2 and 3)
         when current = 0  -->  (0 + 1) % 4 = 1
         when current = 1  -->  (1 + 1) % 4 = 2
         when current = 2  -->  (2 + 1) % 4 = 3
         when current = 3  -->  (3 + 1) % 4 = 0
         */
        let nextIndex = (selectedIndex + 1) % places.count
        setSelectedIndex(to: nextIndex)
    }
    
    func selectPreviousIndex() {
        /*
         If we just set the current index minus 1 we could send the index out of range.
         By subtracting 1 then adding the count of locations then modding the result by the
         count of locations it forces the index to wrap back into range.
         
         eg. if there were 4 locations (0, 1, 2 and 3)
         when current = 0  -->  (0 - 1 + 4) % 4 = 3 % 4 = 3
         when current = 1  -->  (1 - 1 + 4) % 4 = 4 % 4 = 0
         when current = 2  -->  (2 - 1 + 4) % 4 = 5 % 4 = 1
         when current = 3  -->  (3 - 1 + 4) % 4 = 6 % 4 = 2
         */
        let previousIndex = (selectedIndex + places.count - 1) % places.count
        setSelectedIndex(to: previousIndex)
    }
    
    // MARK: - CRUD Operations
    // C - Create a new Place
    func addPlace(withName name:String, latitude:Double, longitude:Double) -> Int {
        
        // Create a new place in the context
        let newPlace = Place(context: self.context)
        newPlace.name = name
        newPlace.latitude = latitude
        newPlace.longitude = longitude
        
        refreshUI()
        return places.count - 1
    }
    
    func addPlaceWithWebcamURL(withName name:String, latitude:Double, longitude:Double, webcamURL:String) -> Int {
    
        // Create a new webcam
        let newWebcam = Webcam(context: self.context)
        newWebcam.url = webcamURL
        
        // Create a new place in the context
        let newPlace = Place(context: self.context)
        newPlace.name = name
        newPlace.latitude = latitude
        newPlace.longitude = longitude
        
        // Add the webcam
        newPlace.webcam = newWebcam
        
        refreshUI()
        return places.count - 1
    }
    
    // U - Update a place
    func renamePlace(atIndex index:Int, withNewName newName:String) {
        if indexIsInRange(index) {
            _places?[index].name = newName
            refreshUI()
        } else {
            print("Index out of range - Unable to rename place at index \(index)")
        }
    }
    
    func updateWeatherForPlace(atIndex index:Int, withWeather weather:Weather) {
        if indexIsInRange(index) {
            _places?[index].weather = weather
        } else {
            print("Index out of range - Unable to update the weather at index \(index)")
        }
    }
    
    // D - Delete a location
    func deletePlace(atIndex index:Int) {
        if indexIsInRange(index) {
            context.delete((_places?[index])!)
            refreshUI()
        }
    }
    
    // Helper functions
    func indexIsInRange(_ index:Int) -> Bool {
        return index >= 0 && index < _places?.count ?? 0
    }
    
    func getJoke() -> String {
        let jokeCount = jokes.count
        let randomJokeIndex = Int(arc4random_uniform(UInt32(jokeCount)))
        guard let j = _jokes?[randomJokeIndex].content else {
            return("Joke 404")
        }
        return j
    }
    
    // MARK: - API Calls
    
    func requestNewJokesfromAPI() {
        let urlString = "https://www.icanhazdadjoke.com/search?page=1&limit=30"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error while calling the jokes API", error)
                }
                if let data = data {
                    // We are good to process the response
                    let decoder = JSONDecoder()
                    
                    if let decodedData = try? decoder.decode(icanhazdadjoke.self, from: data) {
                        for result in decodedData.results {
                            let newJoke = Joke(context: self.context)
                            newJoke.content = result.joke
                        }
                        self.saveContext()
                    }
                }
            }
            task.resume()
        }
    }
    
    func reloadWeatherFromAPI(forPlaceIndex index:Int) {

        // Clear out previous forecast
        self._places?[index].forecast = nil
        
        if let place = _places?[index] {
            let urlString = "https://api.openweathermap.org/data/2.5/onecall"
                + "?lat=\(place.latitude)"
                + "&lon=\(place.longitude)"
                + "&exclude=minutely,hourly,alerts"
                + "&units=metric"
                + "&appid=5eaa5efc251ae94bcfdc432d23779596"
            
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                let task = session.dataTask(with: request, completionHandler: { data, response, downloadError in
                    if let error = downloadError {
                        print(error)
                    } else {
                        let decoder = JSONDecoder()
                        
                        if let decodedData = try? decoder.decode(OWMTodayAndForecast.self, from: data!) {
                            // Today Data
                            let weatherToday = Weather(context: self.context)
                            weatherToday.temp = decodedData.current.temp
                            weatherToday.main = decodedData.current.weather[0].main
                            weatherToday.desc = decodedData.current.weather[0].description
                            weatherToday.icon = decodedData.current.weather[0].icon
                            
                            // add weatherToday to the current place
                            self._places?[index].weather = weatherToday
                            
                            // Forecast Data
                            for day in decodedData.daily {
                                let forecastDay = Forecast(context: self.context)
                                forecastDay.dt = Int64(day.dt)
                                forecastDay.minTemp = day.temp.min
                                forecastDay.maxTemp = day.temp.max
                                
                                // Add the forecast item for this location
                                self._places?[index].addToForecast(forecastDay)
                            }
                            // Finished getting the data
                            self.refreshUI()
                        }
                    }
                })
                task.resume()
            }
        }
    }
    
    func reloadWeatherHistoryFromAPI(forPlaceIndex index:Int) {
        
        // Clear out previous forecast
        self._places?[index].history = nil
        
        if let place = _places?[index] {
            let dtNow = Int(floor((Date().timeIntervalSince1970 / 1000) * 1000))
            for i in 0 ... 5 { // getting today [0] and the last 5 days [1]..[5] of data
                let dt = dtNow - (i * 24 * 60 * 60)
                
                let urlString = "https://api.openweathermap.org/data/2.5/onecall/timemachine"
                    + "?lat=\(place.latitude)"
                    + "&lon=\(place.longitude)"
                    + "&dt=\(dt)"
                    + "&units=metric"
                    + "&appid=5eaa5efc251ae94bcfdc432d23779596"
                // Make an API call for each day
                if let url = URL(string: urlString) {
                    if let data = try? Data(contentsOf: url) {
                        // Parse the data
                        let decoder = JSONDecoder()
                        
                        if let decodedData = try? decoder.decode(OWMHistory.self, from: data) {
                            
                            // History Data
                            let weatherHistory = History(context: context)
                            weatherHistory.dt = Int64(dt)
                            
                            var minTempHour = decodedData.hourly[0].temp
                            var maxTempHour = decodedData.hourly[0].temp
                            
                            // Loop through the hourly data to calculate the min and max for the day
                            for hour in decodedData.hourly {
                                let tempHour = hour.temp
                                minTempHour = min(minTempHour, tempHour)
                                maxTempHour = max(maxTempHour, tempHour)
                            }
                            weatherHistory.minTemp = minTempHour
                            weatherHistory.maxTemp = maxTempHour
                            
                            // Add the history item for this location
                            _places?[index].addToHistory(weatherHistory)
                        }
                    }
                }
            }
        }
    }
    
    func FindNearbyWebcamsFromAPI(latitude:Double, longitude:Double) -> [String] {
        let urlString = "https://api.windy.com/api/webcams/v2/list"
            + "/nearby=\(latitude),\(longitude),50"
            + "/limit=4"
            + "?show=webcams:location,image"
            + "&key=ByApo86bqPdkn3bq3QZBjn8BvDdLyRGF"
        
        var webcamFilenames:[String] = []
        if let url = URL(string: urlString) {
            let data = try? Data(contentsOf: url)
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(Windy.self, from: data!) {
                for result in decodedData.result.webcams {
                    webcamFilenames.append(result.image.current.preview)
                }
            }
        }
        
        return webcamFilenames
    }
}





