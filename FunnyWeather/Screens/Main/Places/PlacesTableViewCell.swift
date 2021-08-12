//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Banner: UIView!
    @IBOutlet weak var PlaceName: UILabel!
    @IBOutlet weak var PlaceTemp: UILabel!
    @IBOutlet weak var PlaceDesc: UILabel!
    @IBOutlet weak var PlaceIcon: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
