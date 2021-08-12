//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import UIKit
import CoreLocation

class AddWebcamViewController: UIViewController {

    var viewModel = AddViewModel()
    
    // These stored properties are populated from the map
    // page through the prepare for segue function
    var SuburbName:String = ""
    var latitude:Double = 0
    var longitude:Double = 0
    
    var urls:[String] = []
    var selectedWebcamURL:String = ""

    var Webcam1ImageURL:String = "" {
        didSet {
            guard let url = URL(string: Webcam1ImageURL) else { return }
            Webcam1Image.downloaded(from: url)
        }
    }
    
    var Webcam2ImageURL:String = "" {
        didSet {
            guard let url = URL(string: Webcam2ImageURL) else { return }
            Webcam2Image.downloaded(from: url)
        }
    }
    
    var Webcam3ImageURL:String = "" {
        didSet {
            guard let url = URL(string: Webcam3ImageURL) else { return }
            Webcam3Image.downloaded(from: url)
        }
    }
    
    var Webcam4ImageURL:String = "" {
        didSet {
            guard let url = URL(string: Webcam4ImageURL) else { return }
            Webcam4Image.downloaded(from: url)
        }
    }
    
    // MARK: - Outlets
    
    @IBAction func SaveButton(_ sender: UIBarButtonItem) {
        if let name = PlaceName.text {
            viewModel.addPlace(withName: name,
                               latitude: latitude,
                               longitude: longitude,
                               webcamURL: selectedWebcamURL)
            self.navigationController?.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBOutlet weak var PlaceName: UITextField!
    
    @IBOutlet weak var Webcam1Border: UIImageView!
    @IBOutlet weak var Webcam1Image: UIImageView!
    @IBAction func Webcam1Button(_ sender: UIButton) {
        selectedWebcam(1)
    }
    
    @IBOutlet weak var Webcam2Border: UIImageView!
    @IBOutlet weak var Webcam2Image: UIImageView!
    @IBAction func Webcam2Button(_ sender: UIButton) {
        selectedWebcam(2)
    }
    
    @IBOutlet weak var Webcam3Border: UIImageView!
    @IBOutlet weak var Webcam3Image: UIImageView!
    @IBAction func Webcam3Button(_ sender: UIButton) {
        selectedWebcam(3)
    }
    
    @IBOutlet weak var Webcam4Border: UIImageView!
    @IBOutlet weak var Webcam4Image: UIImageView!
    @IBAction func Webcam4Button(_ sender: UIButton) {
        selectedWebcam(4)
    }

    func selectedWebcam(_ cam:Int) {
        selectedWebcamURL = urls[cam - 1]
        Webcam1Border.backgroundColor = ((cam == 1) ? UIColor.appHighlight : UIColor.clear)
        Webcam2Border.backgroundColor = ((cam == 2) ? UIColor.appHighlight : UIColor.clear)
        Webcam3Border.backgroundColor = ((cam == 3) ? UIColor.appHighlight : UIColor.clear)
        Webcam4Border.backgroundColor = ((cam == 4) ? UIColor.appHighlight : UIColor.clear)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reverse Geocode to find the suburb
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) {
            (places, error) in
            if places?[0] != nil {
                if self.PlaceName.text == "" {
                    self.PlaceName.text = places?[0].locality!
                }
            }
        }
        
        urls = viewModel.FindNearbyWebcamsFromAPI(latitude: latitude, longitude: longitude)
        // manually trigger the didSet
        if urls.count >= 1 { Webcam1ImageURL = urls[0] }
        if urls.count >= 2 { Webcam2ImageURL = urls[1] }
        if urls.count >= 3 { Webcam3ImageURL = urls[2] }
        if urls.count >= 4 { Webcam4ImageURL = urls[3] }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PlaceName.text = SuburbName
    }
}

extension UIImageView {
    
    func downloaded(from url:URL) {
        contentMode = .scaleAspectFill
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType .hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
