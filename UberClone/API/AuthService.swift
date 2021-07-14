//
//  Service.swift
//  UberClone
//
//  Created by Apple on 2.06.2021.
//

import UIKit
import Firebase
import GeoFire

struct AuthCredentials {
    
    let email: String
    let accountTypeIndex: Int
    let password: String
    let fullname: String
}

struct AuthService {
    
    static func logUserIn(withEmail email: String,password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredentials credentials: AuthCredentials, completion: @escaping((Error?, DatabaseReference) -> Void)) {
        
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
            if let error = error {
                print("DEBUG: During api call for creating user the error appears to be \(error.localizedDescription)")
            }
            
            guard let uid = result?.user.uid else { return }

            if credentials.accountTypeIndex == 1 {
            }
            let sharedLocationManager = LocationHandler.shared.locationManager
            guard let location = sharedLocationManager?.location else { return }
            let geoFire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
            geoFire.setLocation(location, forKey: uid) { (err) in
             print("test \(location)")
            }
            
            let values = ["email": credentials.email,
                          "name": credentials.fullname,
                          "accountType": credentials.accountTypeIndex] as [String: Any]
            
            REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
            }
            
        }
    }

