//
//  LocationViewModel.swift
//  UberClone
//
//  Created by Apple on 8.06.2021.
//

import MapKit
import GoogleMaps
import GooglePlaces
import UIKit

struct LocationViewModel {
    
    private var place: GMSPlace
    let name: String
    let adress: String
    
    
    init(place: GMSPlace) {
        self.place = place
        
       
        self.name = place.name ?? ""
        self.adress = place.formattedAddress ?? ""
    }
}
