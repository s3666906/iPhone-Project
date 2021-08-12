//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import UIKit

class AboutUsDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    var student: Student?=Student.thomas {
        didSet {
            refreshUI()
        }
    }
    
    private func refreshUI() {
        loadViewIfNeeded()
        if let student = student {
            nameLabel.text = student.name
            numberLabel.text = student.number
            imageView.image = UIImage(imageLiteralResourceName: student.imageName)
            descLabel.text = student.desc
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshUI();
    }
}
