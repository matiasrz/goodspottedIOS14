//
//  ExploreViewController.swift
//  FoodFinder IOS14
//
//  Created by Matias Rojas Zuñiga on 11/11/2020.
//

import UIKit
import CoreLocation
import MapKit

class ExploreViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    var storeManager = StoreManager()
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        storeManager.delegate = self
    }
}

// MARK: - StoreManagerDelegate
extension ExploreViewController: StoreManagerDelegate {
    func didUpdateStore(_ storeManager: StoreManager, _ store: StoreModel) {
        DispatchQueue.main.async { [self] in
            print(store)
            let pin = MKPointAnnotation()
            pin.coordinate = store.location
            pin.title = store.name
//            pin.subtitle = "The tallest buildiing in the world."
            mapView.addAnnotation(pin)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - CLLocationManagerDelegate
extension ExploreViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            let location = CLLocation(latitude: lat, longitude: lon)
            mapView.centerToLocation(location)
            storeManager.fetchStore()
        }
    }
}

// MARK: - Center Location custom function
private extension MKMapView {
  func centerToLocation( _ location: CLLocation, regionRadius: CLLocationDistance = 2000) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius
    )
    setRegion(coordinateRegion, animated: true)
  }
}
