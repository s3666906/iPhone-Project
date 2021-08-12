//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var dt: Int64
    @NSManaged public var maxTemp: Double
    @NSManaged public var minTemp: Double
    @NSManaged public var place: Place?

}
