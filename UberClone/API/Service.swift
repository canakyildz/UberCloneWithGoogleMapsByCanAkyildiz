//
//  Service.swift
//  UberClone
//
//  Created by Apple on 2.06.2021.
//

import Firebase
import CoreLocation
import GeoFire

struct Service {
    
    // MARK: - Fetches & Observations
    
    static func fetchUserData(withUid currentUid: String,completion: @escaping(User) -> Void) {
        
        REF_USERS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: currentUid, dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchDrivers(location: CLLocation, completion: @escaping(User) -> Void) {
        let geoFire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        REF_DRIVER_LOCATIONS.observe(.value) { (snapshot) in
            geoFire.query(at: location, withRadius: 50).observe(.keyEntered, with: { (uid, location) in
                self.fetchUserData(withUid: uid) { (user) in
                    let driver = user
                    driver.location = location
                    completion(driver)
                }
            })
            }
    }
    
    static func observeTrips(completion: @escaping(Trip) -> Void) {
        REF_TRIPS.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            let trip = Trip(passengerUid: uid, dictionary: dictionary)
            completion(trip)
        }
    }
    
    // MARK: - Uploads

    static func uploadTrip(_ pickupCoordinates: CLLocationCoordinate2D, _ destinationCoordinates: CLLocationCoordinate2D, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let pickupArray = [pickupCoordinates.latitude, destinationCoordinates.longitude]
        let destinationArray = [pickupCoordinates.latitude, destinationCoordinates.longitude]
        let values = ["pickupCoordinates": pickupArray, "destinationCoordinates": destinationArray, "state": TripState.requested.rawValue] as [String: Any]
        
        REF_TRIPS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    // MARK: - Other calls
    
    static func acceptTrip(trip: Trip, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let driverUid = Auth.auth().currentUser?.uid else { return }
        let updatedValues = ["driverUid": driverUid, "state": TripState.accepted.rawValue] as [String : Any]
        
        REF_TRIPS.child(trip.passengerUid).updateChildValues(updatedValues, withCompletionBlock: completion)
    }
    
}
