//
//  RideActionViewModel.swift
//  UberClone
//
//  Created by Apple on 9.06.2021.
//

import GooglePlaces
import GoogleMaps

struct RideActionViewModel {
    
    
    private var place: GMSPlace
    let name: String
    let adress: String
    
    
    init(place: GMSPlace) {
        self.place = place
        
       
        self.name = place.name ?? ""
        self.adress = place.formattedAddress ?? ""
    }
}
