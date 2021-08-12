//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddMapViewController: UIViewController {

    var locationManager: CLLocationManager!
    var searchInputView: LocationSearchInputView!

    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let centerMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "location-arrow-flat").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self,
                         action: #selector(handleCenterOnUserLocation),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        configureLocationManager()
        enableLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centerMapOnUserLocation()
    }
    
    // MARK: - Functions
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    @objc func handleCenterOnUserLocation() {
        centerMapOnUserLocation()
    }
}

extension AddMapViewController:MKMapViewDelegate {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToWebcams" {
            let destVC = segue.destination as! AddWebcamViewController
            let mapCenter = mapView.centerCoordinate
            destVC.latitude = Double(mapCenter.latitude)
            destVC.longitude = Double(mapCenter.longitude)
        }
    }
}

// MARK: - Extensions

extension AddMapViewController: CLLocationManagerDelegate {
    
    func enableLocationServices() {
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            DispatchQueue.main.async {
                let controller = LocationRequestController()
                controller.locationManager = self.locationManager

                self.present(controller, animated: true, completion: nil)
            }
        case .restricted:
            print("Locations Auth status is restricted")
        case .denied:
            print("Locations Auth status is denied")
        case .authorizedAlways:
            print("Locations Auth status is authorized always")
        case .authorizedWhenInUse:
            print("Locations Auth status is authorized when in use")
        @unknown default:
            print("Locations Auth status is unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }

    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 3000, 3000)
        mapView.setRegion(region, animated: true)
    }
}

extension AddMapViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Ignore user input while searching
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Create the busy indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        // Show indicator
        self.view.addSubview(activityIndicator)
        
        // Build the search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                print("error searching")
            } else {
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
}

