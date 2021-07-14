////
////  CommentedForMKMAP.swift
////  UberClone
////
////  Created by Apple on 21.06.2021.
////
//
//func polylineAnimating(coordinatesInArray: [CLLocationCoordinate2D], completion: ((Timer) -> Void)?) {
//    self.drawingTimer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { [weak self] timer in
//        guard let self = self else {
//            // Invalidate animation if we can't retain self
//            timer.invalidate()
//            return
//        }
//
//        if let previous = self.previousSegment {
//            // Remove last drawn segment if needed.
//            self.mapView.removeOverlay(previous)
//            self.previousSegment = nil
//        }
//
//        guard self.currentStep < self.totalSteps else {
//            // If this is the last animation step...
//            var finalPolyline = MKPolyline(coordinates: coordinatesInArray, count: coordinatesInArray.count)
//            if let route = self.route {
//                finalPolyline = route.polyline
//                self.mapView.addOverlay(finalPolyline)
//                // Assign the final polyline instance to the class property.
//            }
//            return
//        }
//
//        // Animation step.
//        // The current segment to draw consists of a coordinate array from 0 to the 'currentStep' taken from the route.
//        let subCoordinates = Array(coordinatesInArray.prefix(upTo: self.currentStep))
//        let currentSegment = MKPolyline(coordinates: subCoordinates, count: subCoordinates.count)
//
//        self.mapView.addOverlay(currentSegment)
//        self.previousSegment = currentSegment
//
//        if coordinatesInArray.count > 200 {
//            self.currentStep += 3
//
//        } else if coordinatesInArray.count > 500 {
//            self.currentStep += 15
//        } else if coordinatesInArray.count > 1000 {
//            self.currentStep += 30
//        } else {
//            self.currentStep += 2
//        }
//        // if you want a similar animation same as uber
//        self.loopForPolyLineAnimation(arrayOfCordinates: coordinatesInArray, enabled: false)
//    }
//}
//
//func loopForPolyLineAnimation(arrayOfCordinates: [CLLocationCoordinate2D], enabled: Bool) {
//    if enabled == false {
//        print("DEBUG: Infinitive loop is not enabled, to enable it, change it through settings. ")
//    } else {
//        if self.currentStep >= arrayOfCordinates.count {
//            self.mapView.removeOverlays(self.mapView.overlays)
//            guard !self.mapView.overlays.isEmpty else {
//                self.drawingTimer?.invalidate()
//                self.currentStep = 1
//                self.drawingTimer?.fire()
//                self.arrayOfCoordinatesInRoute.removeAll()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//
//                    self.polylineAnimating(coordinatesInArray: arrayOfCordinates, completion: nil)
//                }
//                return
//            }
//        }
//    }
//}


//func animate(forDestination destination: MKMapItem,points: [CLLocationCoordinate2D], duration: TimeInterval, completion: (() -> Void)?) {
//    
//    let request = MKDirections.Request()
//    request.source = MKMapItem.forCurrentLocation() //this where we gonna start from
//    request.destination = destination
//    request.transportType = .automobile
//    
//    let directionRequest = MKDirections(request: request)
//    directionRequest.calculate { (response, error) in
//        guard let response = response else { return }
//        self.route = response.routes[0]//apple map generates multiple directions for one destination point for most the time; we want to grab the first one
//        let cordis = response.routes[0].polyline.coordinates
//        cordis.forEach { (cordi) in
//            self.arrayOfCoordinatesInRoute.append(cordi)
//        }
//        
//        guard cordis.count > 0 else { return }
//        self.makePolylineAnimation(route: cordis)
//        
//    }
//
//}
