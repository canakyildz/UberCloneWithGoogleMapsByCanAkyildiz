//
//   .swift
//  UberClone
//
//  Created by Apple on 7.06.2021.
//

import GoogleMaps

class DriverMarker: GMSMarker {
    dynamic var coordinate: CLLocationCoordinate2D //for that animation functionality below to work, we had to add "dynamic" front of var, it helps us have changes during runtime. Strong variables are not enough to perform momentary changes or at least takes time or requires constant api calls even though we have observe
    var uid: String
    
    init(uid: String, coordinate: CLLocationCoordinate2D) {
        self.uid = uid
        self.coordinate = coordinate
        
        
    }
    
    func updateAnnotationPosition(withCoordinate coordinate: CLLocationCoordinate2D) {
        UIView.animate(withDuration: 0.2) {
            self.coordinate = coordinate
        }
    }

    
    
}
