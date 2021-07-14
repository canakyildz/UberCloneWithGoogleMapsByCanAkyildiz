//
//  Trip.swift
//  UberClone
//
//  Created by Apple on 9.06.2021.
//

import CoreLocation

struct Trip {
    
    var pickupCoordinates: CLLocationCoordinate2D!
    var destinationCoordinates: CLLocationCoordinate2D!
    let passengerUid: String
    var driverUid: String?
    var state: TripState!
    //a trip doesnt always start with a driver, driver doesnt come until driver accepts but always going to have passengeruid
    //initilizing with passengeruid because the dictionary doenst involve pUid it's header of it
    init(passengerUid: String, dictionary: [String: Any]) {
        self.passengerUid = passengerUid
        
        if let pickupCoordinates = dictionary["pickupCoordinates"] as? NSArray {
            guard let latitude = pickupCoordinates[0] as? CLLocationDegrees else { return }
            guard let longtitude = pickupCoordinates[1] as? CLLocationDegrees else { return }
            self.pickupCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            
        }
        
        if let destinationCoordinates = dictionary["destinationCoordinates"] as? NSArray {
            guard let latitude = destinationCoordinates[0] as? CLLocationDegrees else { return }
            guard let longtitude = destinationCoordinates[1] as? CLLocationDegrees else { return }
            self.destinationCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        }
        
        self.driverUid = dictionary["driverUid"] as? String ?? ""
        
        if let state = dictionary["state"] as? Int {
            self.state = TripState(rawValue: state)
        }
        
    }
    
}
