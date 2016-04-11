//
//  SearchViewController.swift
//  MyRoute
//
//  Created by xiaoming han on 15/1/6.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate, UIGestureRecognizerDelegate {

    var mapView: MAMapView!
    var search: AMapSearchAPI!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Search Demo"
        
        initMapView()
        initSearch()
        initToolBar()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingMode.Follow
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Helpers
    
    func initMapView() {
        
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        self.view.addSubview(mapView!)
    }
    
    func initSearch() {
//        AMap
        search = AMapSearchAPI()
        search.delegate = self
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
    
    func searchReGeocodeWithCoordinate(coordinate: CLLocationCoordinate2D!) {
        let regeo: AMapReGeocodeSearchRequest = AMapReGeocodeSearchRequest()
        
        regeo.location = AMapGeoPoint.locationWithLatitude(CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        print("regeo :\(regeo)")
        
        self.search!.AMapReGoecodeSearch(regeo)
    }
    
    //MARK:- MAMapViewDelegate
    
    func mapView(mapView: MAMapView!, didLongPressedAtCoordinate coordinate: CLLocationCoordinate2D) {
        searchReGeocodeWithCoordinate(coordinate)
    }
    
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        if updatingLocation {
           print("location :\(userLocation.location)")
        }
    }

    func mapView(mapView: MAMapView, viewForAnnotation annotation: MAAnnotation) -> MAAnnotationView? {
        
        if annotation.isKindOfClass(MAPointAnnotation) {
            let annotationIdentifier = "invertGeoIdentifier"
            
            var poiAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) as? MAPinAnnotationView
            
            if poiAnnotationView == nil {
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            }
            poiAnnotationView!.pinColor = MAPinAnnotationColor.Green
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
            renderer.lineWidth = 2.0
            
            return renderer
        }
        
        return nil
    }
    
    func mapView(mapView: MAMapView!, didAddAnnotationViews views: [AnyObject]!) {
        let annotationView: MAAnnotationView! = views[0] as! MAAnnotationView
        mapView.selectAnnotation(annotationView.annotation, animated: true)
    }
    
    //MARK:- AMapSearchDelegate
    
    func AMapSearchRequest(request: AnyObject!, didFailWithError error: NSError!) {
        print("request :\(request), error: \(error)")
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
    
    func onPOISearchDone(request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        let pois = response.pois as! [AMapPOI];
        
        for poi in pois {
            NSLog("%f, %f", poi.location.latitude, poi.location.longitude)
        }
    }

}
