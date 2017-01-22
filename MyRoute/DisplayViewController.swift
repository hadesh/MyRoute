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
    var myLocation: MAAnimatedAnnotation?
    
    var isPlaying: Bool = false
    
    var traceCoordinates: Array<CLLocationCoordinate2D> = []
    var duration: Double = 0.0
    
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.gray
        
        initMapView()
        
        initToolBar()
        
        showRoute()
    }
    
    func initMapView() {
        
        mapView = MAMapView(frame: self.view.bounds)
        mapView!.delegate = self
        self.view.addSubview(mapView!)
        self.view.sendSubview(toBack: mapView!)
    }
    
    func initToolBar() {
        
        let playButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_play.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(DisplayViewController.actionPlayAndStop))
        
        navigationItem.rightBarButtonItem = playButtonItem
    }
    
    func showRoute() {
        
        if route == nil || route!.locations.count == 0 {
            print("Invalid route")
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

        mapView!.add(polyline)
        
        mapView!.showAnnotations(mapView!.annotations, animated: true)
        
        /// init the trace coordinates
        traceCoordinates = self.route!.coordinates()
        duration = self.route!.totalDuration() / 2.0;
    }
    
    //MARK:- Helpers
    
    func actionPlayAndStop() {
        print("actionPlayAndStop")
        
        if route == nil {
            return
        }
        
        isPlaying = !isPlaying
        
        if isPlaying {
            navigationItem.rightBarButtonItem!.image = UIImage(named: "icon_stop.png")
            
            if myLocation == nil {
                myLocation = MAAnimatedAnnotation()
                myLocation!.title = "AMap"
                myLocation!.coordinate = route!.startLocation()!.coordinate
                
                mapView!.addAnnotation(myLocation)
            }
            
            weak var weakSelf = self

            self.myLocation!.addMoveAnimation(withKeyCoordinates: &traceCoordinates, count: UInt(traceCoordinates.count), withDuration: CGFloat(duration), withName: "", completeCallback: { (isFinished) in
                
                if isFinished {
                    weakSelf?.actionPlayAndStop()
                }
            })
        }
        else {
            navigationItem.rightBarButtonItem!.image = UIImage(named: "icon_play.png")
            for animation: MAAnnotationMoveAnimation in (self.myLocation?.allMoveAnimations())! {
                animation.cancel()
            }
            myLocation?.coordinate = traceCoordinates[0]
            myLocation?.movingDirection = 0.0
        }
    }
    
    //MARK:- MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView, viewFor annotation: MAAnnotation) -> MAAnnotationView? {
        
        if annotation.isEqual(myLocation) {
            
            let annotationIdentifier = "myLcoationIdentifier"
            
            var poiAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
            if poiAnnotationView == nil {
                poiAnnotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            }
            
            poiAnnotationView?.image = UIImage(named: "car1")
            poiAnnotationView!.canShowCallout = false
            
            return poiAnnotationView;
        }
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let annotationIdentifier = "lcoationIdentifier"
            
            var poiAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MAPinAnnotationView
            
            if poiAnnotationView == nil {
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            }
            
            poiAnnotationView!.animatesDrop   = true
            poiAnnotationView!.canShowCallout = true
            
            return poiAnnotationView;
        }
        
        return nil
    }

    func mapView(_ mapView: MAMapView, rendererFor overlay: MAOverlay) -> MAOverlayRenderer? {
        
        if overlay.isKind(of: MAPolyline.self) {
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.red
            renderer.lineWidth = 6.0
            
            return renderer
        }
        
        return nil
    }

}
