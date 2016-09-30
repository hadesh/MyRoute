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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingMode.follow
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
        prompts.frame = CGRect(x: 0, y: self.view.bounds.height - 44, width: self.view.bounds.width, height: 44)
        
        prompts.text = "Long press to add Annotation"
        prompts.textAlignment = NSTextAlignment.center
        prompts.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        prompts.textColor = UIColor.white
        prompts.font = UIFont.systemFont(ofSize: 14)
        
        prompts.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleWidth]
        
        self.view.addSubview(prompts)
    }
    
    func searchReGeocodeWithCoordinate(coordinate: CLLocationCoordinate2D!) {
        let regeo: AMapReGeocodeSearchRequest = AMapReGeocodeSearchRequest()
        
        regeo.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        print("regeo :\(regeo)")
        
        self.search!.aMapReGoecodeSearch(regeo)
    }
    
    //MARK:- MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView!, didLongPressedAt coordinate: CLLocationCoordinate2D) {
        searchReGeocodeWithCoordinate(coordinate: coordinate)
    }
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        if updatingLocation {
           print("location :\(userLocation.location)")
        }
    }

    func mapView(_ mapView: MAMapView, viewFor annotation: MAAnnotation) -> MAAnnotationView? {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let annotationIdentifier = "invertGeoIdentifier"
            
            var poiAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MAPinAnnotationView
            
            if poiAnnotationView == nil {
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            }
            poiAnnotationView!.pinColor = MAPinAnnotationColor.green
            poiAnnotationView!.animatesDrop   = true
            poiAnnotationView!.canShowCallout = true
            
            return poiAnnotationView;
        }
        return nil
    }
    
    // - (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay;
    func mapView(_ mapView: MAMapView, rendererFor overlay: MAOverlay) -> MAOverlayRenderer? {
        
        if overlay.isKind(of: MACircle.self) {
            let renderer: MACircleRenderer = MACircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.green.withAlphaComponent(0.4)
            renderer.strokeColor = UIColor.red
            renderer.lineWidth = 2.0
            
            return renderer
        }
        
        return nil
    }
    
    private func mapView(mapView: MAMapView!, didAddAnnotationViews views: [AnyObject]!) {
        let annotationView: MAAnnotationView! = views[0] as! MAAnnotationView
        mapView.selectAnnotation(annotationView.annotation, animated: true)
    }
    
    //MARK:- AMapSearchDelegate
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("request :\(request), error: \(error)")
    }
    
    //    - (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest, response: AMapReGeocodeSearchResponse) {
        
        print("request :\(request)")
        print("response :\(response)")
        
        if (response.regeocode != nil) {
            let coordinate = CLLocationCoordinate2DMake(Double(request.location.latitude), Double(request.location.longitude))
            
            let annotation = MAPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = response.regeocode.formattedAddress
            annotation.subtitle = response.regeocode.addressComponent.province
            mapView!.addAnnotation(annotation)
            
            let overlay = MACircle(center: coordinate, radius: 50.0)
            mapView!.add(overlay)
        }
    }
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        let pois = response.pois as [AMapPOI];
        
        for poi in pois {
            NSLog("%f, %f", poi.location.latitude, poi.location.longitude)
        }
    }

}
