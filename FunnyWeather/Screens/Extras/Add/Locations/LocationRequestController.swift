//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import UIKit
import CoreLocation

class LocationRequestController: UIViewController {
    
    var locationManager: CLLocationManager?
    
    let imageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "blue-pin")
        return iv
    }()
    
    let allowLocationLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "Allow Location\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)])
        
        attributedText.append(NSMutableAttributedString(string: "Please allow location services so that we can provide weather services", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]))
        
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedText
        
        return label
    }()
    
    let enableLocationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Enable Location", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.appHighlight
        button.addTarget(self, action: #selector(handleRequestLocation), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
    }

    @objc func handleRequestLocation() {
        guard let locationManager = self.locationManager else { return}
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func configureViewComponents() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 140).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(allowLocationLabel)
        allowLocationLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32).isActive = true
        allowLocationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        allowLocationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        allowLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        allowLocationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(enableLocationButton)
        enableLocationButton.topAnchor.constraint(equalTo: allowLocationLabel.bottomAnchor, constant: 24).isActive = true
        enableLocationButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        enableLocationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        enableLocationButton.translatesAutoresizingMaskIntoConstraints = false
        enableLocationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        enableLocationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

extension LocationRequestController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard locationManager?.location != nil else {
            print("Error setting location...")
            return
        }
        dismiss(animated: true, completion: nil)
    }
}
