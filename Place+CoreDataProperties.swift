//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var forecast: NSSet?
    @NSManaged public var history: NSSet?
    @NSManaged public var weather: Weather?
    @NSManaged public var webcam: Webcam?

}

// MARK: Generated accessors for forecast
extension Place {

    @objc(addForecastObject:)
    @NSManaged public func addToForecast(_ value: Forecast)

    @objc(removeForecastObject:)
    @NSManaged public func removeFromForecast(_ value: Forecast)

    @objc(addForecast:)
    @NSManaged public func addToForecast(_ values: NSSet)

    @objc(removeForecast:)
    @NSManaged public func removeFromForecast(_ values: NSSet)

}

// MARK: Generated accessors for history
extension Place {

    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: History)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: History)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSSet)

}
