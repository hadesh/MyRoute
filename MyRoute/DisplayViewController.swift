//
//  DisplayViewController.swift
//  MyRoute
//
//  Created by xiaoming han on 14-7-21.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

import UIKit

class DisplayViewController: UIViewController, MAMapViewDelegate {

    var route: Route?
    var mapView: MAMapView?
    var myLocation: MAPointAnnotation?
    
    var isPlaying: Bool = false
    var currentLocationIndex: Int = 0
    var averageSpeed: Double = 0.001
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.grayColor()
        
        initMapView()
        
        initToolBar()
        
        showRoute()
    }
    
    func initMapView() {
        
        mapView = MAMapView(frame: self.view.bounds)
        mapView!.delegate = self
        self.view.addSubview(mapView!)
        self.view.sendSubviewToBack(mapView!)
    }
    
    func initToolBar() {
        
        let playButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_play.png"), style: UIBarButtonItemStyle.Bordered, target: self, action: "actionPlayAndStop")
        
        navigationItem.rightBarButtonItem = playButtonItem
    }
    
    func showRoute() {
        
        if route == nil || route!.locations.count == 0 {
            print("Invalid route", appendNewline: false)
            return
        }
        
        let starPoint = MAPointAnnotation()
        starPoint.coordinate = route!.startLocation()!.coordinate
        starPoint.title = "Start"
        
        mapView!.addAnnotation(starPoint)
        
        
        let endPoint = MAPointAnnotation()
        endPoint.coordinate = route!.endLocation()!.coordinate
        endPoint.title = "End"
        
        mapView!.addAnnotation(endPoint)
        
        var coordiantes: [CLLocationCoordinate2D] = route!.coordinates()
        
        let polyline = MAPolyline(coordinates: &coordiantes, count: UInt(coordiantes.count))

        mapView!.addOverlay(polyline)
        
        mapView!.showAnnotations(mapView!.annotations, animated: true)
        
        ///
        averageSpeed = route!.totalDistance() / route!.totalDuration()
    }
    
    //MARK:- Helpers
    
    func actionPlayAndStop() {
        print("actionPlayAndStop", appendNewline: false)
        
        if route == nil {
            return
        }
        
        isPlaying = !isPlaying
        
        if isPlaying {
            navigationItem.rightBarButtonItem!.image = UIImage(named: "icon_stop.png")
            
            if myLocation == nil {
                myLocation = MAPointAnnotation()
                myLocation!.title = "AMap"
                myLocation!.coordinate = route!.startLocation()!.coordinate
                
                mapView!.addAnnotation(myLocation)
            }
            
            animateToNextCoordinate()
        }
        else {
            navigationItem.rightBarButtonItem!.image = UIImage(named: "icon_play.png")
            
            let view: MAAnnotationView? = mapView!.viewForAnnotation(myLocation)
            if view != nil {
                view!.layer.removeAllAnimations()
            }
            
        }
    }
    
    func coordinateHeading(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        
        if !CLLocationCoordinate2DIsValid(from) || !CLLocationCoordinate2DIsValid(to) {
            return 0.0
        }
        
        let delta_lat_y: Double = to.latitude - from.latitude
        let delta_lon_x: Double = to.longitude - from.longitude
        
        if fabs(delta_lat_y) < 0.000001 {
            return delta_lon_x < 0.0 ? 270.0 : 90.0
        }
        
        var heading: Double = atan2(delta_lon_x, delta_lat_y) / M_PI * 180.0
        
        if heading < 0.0 {
            heading += 360.0
        }
        return heading
    }
    
    func animateToNextCoordinate() {
        
        if myLocation == nil {
            return
        }
        
        let coordiantes: [CLLocationCoordinate2D] = route!.coordinates()
        
        if currentLocationIndex == coordiantes.count {
            currentLocationIndex = 0
            actionPlayAndStop()
            return
        }

        let nextCoord: CLLocationCoordinate2D = coordiantes[currentLocationIndex]
        
        let prevCoord: CLLocationCoordinate2D = currentLocationIndex == 0 ? nextCoord : myLocation!.coordinate
        
        let heading: Double = coordinateHeading(prevCoord, to: nextCoord)
        
        let distance: CLLocationDistance  = MAMetersBetweenMapPoints(MAMapPointForCoordinate(nextCoord), MAMapPointForCoordinate(prevCoord));
       
        let duration: NSTimeInterval = distance / (averageSpeed * 100)

        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.myLocation!.coordinate = nextCoord
            return
            }, completion: { (stop: Bool) -> Void in
                self.currentLocationIndex++
                if stop {
                    self.animateToNextCoordinate()
                }
                return
        })
        
        let view: MAAnnotationView? = mapView!.viewForAnnotation(myLocation)
        if view != nil {
            view!.transform = CGAffineTransformMakeRotation(CGFloat(heading / 180.0 * M_PI));
        }
    }
    
    //MARK:- MAMapViewDelegate
    
    func mapView(mapView: MAMapView, viewForAnnotation annotation: MAAnnotation) -> MAAnnotationView? {
        
        if annotation.isEqual(myLocation) {
            
            let annotationIdentifier = "myLcoationIdentifier"
            
            var poiAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier)
            if poiAnnotationView == nil {
                poiAnnotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            }
            
            poiAnnotationView.image = UIImage(named: "aeroplane.png")
            poiAnnotationView!.canShowCallout = false
            
            return poiAnnotationView;
        }
        
        if annotation.isKindOfClass(MAPointAnnotation) {
            let annotationIdentifier = "lcoationIdentifier"
            
            var poiAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) as? MAPinAnnotationView
            
            if poiAnnotationView == nil {
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            }
            
            poiAnnotationView!.animatesDrop   = true
            poiAnnotationView!.canShowCallout = true
            
            return poiAnnotationView;
        }
        
        return nil
    }

    func mapView(mapView: MAMapView, rendererForOverlay overlay: MAOverlay) -> MAOverlayRenderer? {
        
        if overlay.isKindOfClass(MAPolyline) {
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.redColor()
            renderer.lineWidth = 6.0
            
            return renderer
        }
        
        return nil
    }

}
