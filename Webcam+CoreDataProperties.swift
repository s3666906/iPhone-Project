//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import Foundation
import CoreData


extension Webcam {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Webcam> {
        return NSFetchRequest<Webcam>(entityName: "Webcam")
    }

    @NSManaged public var url: String?
    @NSManaged public var image: NSData?
    @NSManaged public var place: Place?

}
