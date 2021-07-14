//
//  LocationHandler.swift
//  UberClone
//
//  Created by Apple on 4.06.2021.
//

import CoreLocation
import GooglePlaces
import MapKit

struct Place {
    let name: String
    let identifier: String
}

enum PlacesError: Error {
    case failed
}

class LocationHandler: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationHandler()
    var locationManager: CLLocationManager!
    var location: CLLocation?
    var client = GMSPlacesClient.shared()
    var selectedLocation: GMSPlace?
    var nearbyPlaces: [GMSPlace] = []
    var zoomLevel: Float = 15.0
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
  
    
}
