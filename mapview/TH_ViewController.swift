//
//  ViewController.swift
//  mapview
//
//  Created by diamond on 09.05.16.
//  Copyright (c) 2016 diamond. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TH_ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    

    var mapView: MKMapView!
    var places:Array<MKAnnotation>!
    var usersLocation:CLLocation!
    var annotation:MKAnnotation!
    var region:MKCoordinateRegion!
    
    
    private struct Constants {
        static let distance:CLLocationDistance = 1000
        static let latitudeDelta:Double = 0.112872
        static let longitudeDelta:Double = 0.109863
        static let annotationIdentifier = "annotation"

    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        //create Mapview 
        self.mapView = MKMapView(frame: self.view.bounds)
        self.mapView.delegate = self
        
        var distance:CLLocationDistance = Constants.distance
        
        if usersLocation != nil{
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: usersLocation.coordinate.latitude, longitude: usersLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: Constants.latitudeDelta, longitudeDelta: Constants.longitudeDelta))
            
            self.mapView.region = region;
            self.mapView.addAnnotations(places);
            self.mapView.showsUserLocation = true
            self.mapView.showsPointsOfInterest = true
            self.mapView.showsBuildings = true
        }
        self.view.addSubview(self.mapView)
        
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        mapView.setCenterCoordinate(usersLocation.coordinate, animated: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation.isKindOfClass(MKUserLocation)){
            return nil
        }
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(Constants.annotationIdentifier) as?MKPinAnnotationView
        if anView == nil {
            anView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.annotationIdentifier)
            anView!.canShowCallout = true
            anView!.pinColor = .Purple
            anView!.animatesDrop = true
        }
        else {
            anView!.annotation = annotation
        }
        return anView
    }
    
    func mapView(mapView: MKMapView!, didAddAnnotationViews views: [AnyObject]!) {
      println("annotations added")
    }
}

    