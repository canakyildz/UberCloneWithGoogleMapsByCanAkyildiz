//
//  AnimatePolyline.swift
//  UberClone
//
//  Created by Apple on 14.06.2021.
//

import UIKit
import MapKit

struct MapSourceDestinationStruct
{
    var sourceCoordinate : CLLocationCoordinate2D? = nil
    var destinationCoordinate : CLLocationCoordinate2D? = nil
}

//defaultStepCount is the count of points needed between source and destiation coordinates
//let defaultStepCount = 20
public class MapKitPathRenderer: NSObject
{
    public func getRoutePathBetween(source : CLLocationCoordinate2D , destination : CLLocationCoordinate2D , straightLinePath : Bool = true ,steps : Int = 20) -> (MKPolyline?, [CLLocationCoordinate2D]?)
    {
        if straightLinePath == true
        {
            //Return  straight line route between source, destination points
            return MKPRStraightLineRoute.init().getRoutePathBetween(source: source, destination: destination, steps: steps)
        }
        
        return (nil , nil)
    }
    
    func getRoutesForSourceDestinatonStructArray(_ sdArray : [MapSourceDestinationStruct] ,straightLinePath : Bool = true, steps : Int = 20) -> [MKPolyline]
    {
        var routes : [MKPolyline] = Array<MKPolyline>.init()
        if straightLinePath == true
        {
            //Return multiple straight line routes for multiple source, destination points in sdArray
            routes = MKPRStraightLineRoute.init().getRoutesForSourceDestinatonStructArray(sdArray, steps: steps)
        }
        return routes
    }
}

public extension MKMultiPoint {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
                                              count: pointCount)

        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))

        return coords
    }
}
extension UIBezierPath {
    convenience init(points:[CGPoint])
    {
        self.init()

        //connect every points by line.
        //the first point is start point
        for (index,aPoint) in points.enumerated()
        {
            if index == 0 {
                self.move(to: aPoint)
            }
            else {
                self.addLine(to: aPoint)
            }
        }
    }
}

extension CAShapeLayer
{
    convenience init(path:UIBezierPath, lineColor:UIColor, fillColor:UIColor)
    {
        self.init()
        self.path = path.cgPath
        self.strokeColor = lineColor.cgColor
        self.fillColor = fillColor.cgColor
        self.lineWidth = path.lineWidth

        self.opacity = 1
        self.frame = path.bounds
    }
}

