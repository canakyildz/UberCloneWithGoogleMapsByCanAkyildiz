//
//  User.swift
//  UberClone
//
//  Created by Apple on 4.06.2021.
//

import Foundation
import CoreLocation

enum AccountType: Int {
    case passenger
    case driver
}

class User {
    
    var accountType: AccountType!
    var email: String
    var fullname: String
    var location: CLLocation?
    var uid: String
    
    
    init(uid: String,dictionary: [String: Any]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["name"] as? String ?? ""
        
        if let index = dictionary["accountType"] as? Int {
            self.accountType = AccountType(rawValue: index)
        }
        
    }
}
