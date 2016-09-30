//
//  Route.swift
//  MyRoute
//
//  Created by xiaoming han on 14-7-21.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

import Foundation

class Route: NSObject, NSCoding {
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(startTime, forKey: "startTime")
        aCoder.encode(endTime, forKey: "endTime")
        aCoder.encode(locations, forKey: "locations")
    }

    
    let distanceFilter: CLLocationDistance = 10
    
    var startTime: NSDate
    var endTime: NSDate
    var locations: Array<CLLocation>
    
    override init() {
        
        startTime = NSDate()
        endTime = startTime
        locations = Array()
    }
    
    deinit {
//        println("deinit")
    }
    
    /// NSCoding

    required init?(coder aDecoder: NSCoder) {
        startTime = aDecoder.decodeObject(forKey: "startTime") as! NSDate
        endTime = aDecoder.decodeObject(forKey: "endTime") as! NSDate
        locations = aDecoder.decodeObject(forKey: "locations") as! Array
    }
    
    /// Interface
    
    func addLocation(location: CLLocation?) -> Bool {
        
        if location == nil {
            return false
        }
        
        let lastLocation: CLLocation? = locations.last
        
        if lastLocation != nil {
            
            let distance: CLLocationDistance = lastLocation!.distance(from: location!)
            
            if distance < distanceFilter {
                return false
            }
        }

        locations.append(location!)
        endTime = NSDate()
        
        return true
    }
    
    func title() -> String! {
        
        let formatter: DateFormatter = DateFormatter()
        formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
        
        return formatter.string(from: self.startTime as Date)
    }
    
    func detail() -> String! {
        return NSString(format: "p: %d, d: %.2fm, t: %@", locations.count, totalDistance(), formattedDuration(duration: totalDuration())) as String
    }
    
    func startLocation() -> CLLocation? {
        return locations.first
    }
    
    func endLocation() -> CLLocation? {
        return locations.last
    }
    
    func totalDistance() -> CLLocationDistance {
        
        var distance: CLLocationDistance = 0
        if locations.count > 1 {
            
            var currentLocation: CLLocation? = nil
            
            for location in locations {

                if currentLocation != nil {
                    distance += location.distance(from: currentLocation!)
                }
                currentLocation = location
            }
            
        }

        return distance
    }
    
    func totalDuration() -> TimeInterval {
        
        return endTime.timeIntervalSince(startTime as Date)
    }
    
    func formattedDuration(duration: TimeInterval) -> String {

        var component: [Double] = [0, 0, 0]
        var t = duration
        
        for i in 0 ..< component.count {
            component[i] = Double(Int(t) % 60)
            t /= 60.0
        }
        
        return NSString(format: "%.0fh %.0fm %.0fs", component[2], component[1], component[0]) as String
    }
    
    func coordinates() -> [CLLocationCoordinate2D]! {
        
        var coordinates: [CLLocationCoordinate2D] = []
        if locations.count > 1 {
            
            for location: AnyObject in locations {
                
                let loc = location as! CLLocation
                
                coordinates.append(loc.coordinate)
            }
        }
        return coordinates
    }
}
