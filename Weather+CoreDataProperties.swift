//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather")
    }

    @NSManaged public var desc: String?
    @NSManaged public var icon: String?
    @NSManaged public var main: String?
    @NSManaged public var temp: Double
    @NSManaged public var place: Place?

}
