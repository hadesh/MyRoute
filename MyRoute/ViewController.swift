//
//  ViewController.swift
//  HelloAmap-Swift
//
//  Created by xiaoming han on 14-7-7.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate, UIGestureRecognizerDelegate {
    
    var mapView: MAMapView?
    var search: AMapSearchAPI?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initMapView()
        initSearch()
        initToolBar()
        initGestureRecognizer()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Helpers
    
    func initMapView() {
        
        mapView = MAMapView(frame: self.view.bounds)
        mapView!.delegate = self
        self.view.addSubview(mapView!)
        
        mapView!.showsUserLocation = true
        mapView!.userTrackingMode = MAUserTrackingMode.Follow
        
        mapView!.setZoomLevel(15.1, animated: true)
    }
    
    func initSearch() {
        search = AMapSearchAPI()
        search?.delegate = self
    }
    
    func initToolBar() {
        let prompts: UILabel = UILabel()
        prompts.frame = CGRectMake(0, self.view.bounds.height - 44, self.view.bounds.width, 44)
        prompts.text = "Long press to add Annotation"
        prompts.textAlignment = NSTextAlignment.Center
        prompts.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        prompts.textColor = UIColor.whiteColor()
        prompts.font = UIFont.systemFontOfSize(14)
        
        prompts.autoresizingMask = [UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleWidth]
        
        self.view.addSubview(prompts)
    }
    
    func initGestureRecognizer() {
        
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        longPress.delegate = self
        self.view.addGestureRecognizer(longPress)
    }
    
    func searchReGeocodeWithCoordinate(coordinate: CLLocationCoordinate2D!) {
        let regeo: AMapReGeocodeSearchRequest = AMapReGeocodeSearchRequest()
        
        regeo.location = AMapGeoPoint.locationWithLatitude(CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        print("regeo :\(regeo)")
        
        self.search!.AMapReGoecodeSearch(regeo)
    }
    
    /// Handle Gesture
    
    //    - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.Began {
            let coordinate = mapView!.convertPoint(gesture.locationInView(self.view), toCoordinateFromView: mapView)
            
            searchReGeocodeWithCoordinate(coordinate)
            
        }
    }
    
    /// MAMapViewDelegate
    
    //- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
    func mapView(mapView: MAMapView , didUpdateUserLocation userLocation: MAUserLocation ) {
        print("location :\(userLocation.location)")
    }
    
    func mapView(mapView: MAMapView, viewForAnnotation annotation: MAAnnotation) -> MAAnnotationView? {
        
        if annotation.isKindOfClass(MAPointAnnotation) {
            let annotationIdentifier = "invertGeoIdentifier"
            
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
    
    // - (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay;
    func mapView(mapView: MAMapView, rendererForOverlay overlay: MAOverlay) -> MAOverlayRenderer? {
        
        if overlay.isKindOfClass(MACircle) {
            let renderer: MACircleRenderer = MACircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.greenColor().colorWithAlphaComponent(0.4)
            renderer.strokeColor = UIColor.redColor()
            renderer.lineWidth = 4.0
            
            return renderer
        }
        
        return nil
    }
    
    
    /// AMapSearchDelegate
    
    // - (void)search:(id)searchRequest error:(NSString*)errInfo;
    func search(searchRequest: AnyObject, error errInfo: String) {
        print("request :\(searchRequest), error: \(errInfo)")
        
    }
    
    //    - (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
    func onReGeocodeSearchDone(request: AMapReGeocodeSearchRequest, response: AMapReGeocodeSearchResponse) {
        
        print("request :\(request)")
        print("response :\(response)")
        
        if (response.regeocode != nil) {
            let coordinate = CLLocationCoordinate2DMake(Double(request.location.latitude), Double(request.location.longitude))
            
            let annotation = MAPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = response.regeocode.formattedAddress
            annotation.subtitle = response.regeocode.addressComponent.province
            mapView!.addAnnotation(annotation)
            
            let overlay = MACircle(centerCoordinate: coordinate, radius: 50.0)
            mapView!.addOverlay(overlay)
        }
    }
    
}

