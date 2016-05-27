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
    

    @IBOutlet weak var mapView: MKMapView!{
        didSet{
            mapView.delegate = self;
        }
    }
    var places:Array<MKAnnotation>!
    var usersLocation:CLLocation!
    var annotation:MKAnnotation!
    
    
    private struct Constants {
        static let distance:CLLocationDistance = 500
        static let latitudeDelta:Double = 0.112872
        static let longitudeDelta:Double = 0.109863
        static let annotationIdentifier = "annotation"

    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        var distance:CLLocationDistance = Constants.distance
        if usersLocation != nil{
                    println("Custom userslocation \(usersLocation.coordinate.latitude)")
                    println("places \(places)")
            var region:MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: usersLocation.coordinate.latitude, longitude: usersLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: Constants.latitudeDelta, longitudeDelta: Constants.longitudeDelta))
      
            self.mapView.region = region;
            self.mapView.addAnnotations(places);
            self.mapView.showAnnotations(places, animated: true)
        }
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
}

    