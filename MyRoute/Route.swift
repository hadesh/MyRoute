//
//  Route.swift
//  MyRoute
//
//  Created by xiaoming han on 14-7-21.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

import Foundation

class Route: NSObject, NSCoding {
    
    let distanceFilter: CLLocationDistance = 10
    
    var startTime: NSDate
    var endTime: NSDate
    var locations: NSMutableArray
    
    override init() {
        
        startTime = NSDate()
        endTime = startTime
        locations = NSMutableArray()
    }
    
    deinit {
//        println("deinit")
    }
    
    /// NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(startTime, forKey: "startTime")
        aCoder.encodeObject(endTime, forKey: "endTime")
        aCoder.encodeObject(locations, forKey: "locations")
    }
    required init?(coder aDecoder: NSCoder) {
        startTime = aDecoder.decodeObjectForKey("startTime") as! NSDate
        endTime = aDecoder.decodeObjectForKey("endTime") as! NSDate
        locations = aDecoder.decodeObjectForKey("locations") as! NSMutableArray
    }
    
    /// Interface
    
    func addLocation(location: CLLocation?) -> Bool {
        
        if location == nil {
            return false
        }
        
        let lastLocation: CLLocation? = locations.lastObject as? CLLocation
        
        if lastLocation != nil {
            
            let distance: CLLocationDistance = lastLocation!.distanceFromLocation(location!)
            
            if distance < distanceFilter {
                return false
            }
        }
        
        locations.addObject(location!)
        endTime = NSDate()
        
        return true
    }
    
    func title() -> String! {
        
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.localTimeZone()
        formatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
        
        return formatter.stringFromDate(self.startTime)
    }
    
    func detail() -> String! {
        return NSString(format: "p: %d, d: %.2fm, t: %@", locations.count, totalDistance(), formattedDuration(totalDuration())) as String
    }
    
    func startLocation() -> CLLocation? {
        
        if locations.count == 0 {
            return nil
        }
        
        return locations.firstObject as? CLLocation
    }
    
    func endLocation() -> CLLocation? {
        
        if locations.count == 0 {
            return nil
        }
        
        return locations.lastObject as? CLLocation
    }
    
    func totalDistance() -> CLLocationDistance {
        
        var distance: CLLocationDistance = 0
        if locations.count > 1 {
            
            var currentLocation: CLLocation?
            
            for location: AnyObject in locations {
                
                let loc = location as! CLLocation

                distance += loc.distanceFromLocation(currentLocation!)
                currentLocation = loc
            }
            
        }

        return distance
    }
    
    func totalDuration() -> NSTimeInterval {
        
        return endTime.timeIntervalSinceDate(startTime)
    }
    
    func formattedDuration(duration: NSTimeInterval) -> String {

        var component: [Double] = [0, 0, 0]
        var t = duration
        
        for i in 0 ..< component.count {
            component[i] = t % 60.0
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
