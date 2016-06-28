//
//  TH_LocalSearchTableViewController.swift
//  mapview
//
//  Created by diamond on 10.05.16.
//  Copyright (c) 2016 diamond. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TH_Annotation: MKPointAnnotation, MKAnnotation{
}


class TH_LocalSearchTableViewController: UITableViewController, CLLocationManagerDelegate,MKMapViewDelegate,UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var searchBar:UISearchBar = {
        
        let sb = UISearchBar()
        sb.placeholder = "Search Here..."
        return sb
        }()
    

    var searchCtrl = UISearchController(searchResultsController: nil)
    
    
    
    let locationManager = CLLocationManager()
    var pointsOfInterest:Array<MKMapItem> = []
    var usersLocationRegion:MKCoordinateRegion!
    var userLocation:CLLocation = CLLocation()
    var matchingItems:Array<MKMapItem> = []
    var annotations:Array<MKAnnotation> = []
    
    
    
    private struct Constants {
        static let latitudeDelta:Double = 0.112872
        static let longitudeDelta:Double = 0.109863
        static let toMapIdentifier = "toMap"
        static let cellId = "cell"
   }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: Constants.cellId)
        searchCtrl.searchResultsUpdater = self
        searchCtrl.dimsBackgroundDuringPresentation = true
        searchCtrl.searchBar.sizeToFit()
        definesPresentationContext = true
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, 320, 100))
        
        tableView.tableHeaderView = searchCtrl.searchBar
        
        tableView.tableHeaderView?.backgroundColor = UIColor.greenColor()
        
        
        
        
        navigationController?.navigationBar.barTintColor = UIColor.purpleColor()
        navigationController?.toolbar.barTintColor = UIColor.grayColor()
        
        
//        if CLLocationManager.locationServicesEnabled(){
//            self.locationManager.delegate = self;
//            self.locationManager.requestWhenInUseAuthorization()
//            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            self.locationManager.startUpdatingLocation()
//            self.searchBar.delegate = self
//            self.searchBar.placeholder = "search here!"
//        }else{
//           let ctrl = UIAlertController(title: "no Services Available", message: "please make sure that you can use locationservices", preferredStyle:UIAlertControllerStyle.Alert)
//        }
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        println("searching")
    }
    //search
    func searchForPointOfInterests(searchString:String){
        if self.usersLocationRegion != nil{
            self.clear()
            let searchRequest = MKLocalSearchRequest()
            searchRequest.naturalLanguageQuery = searchString
            searchRequest.region = self.usersLocationRegion
            
            let localSearch = MKLocalSearch(request: searchRequest)
            let lSCompletionHandler:MKLocalSearchCompletionHandler = {(response:MKLocalSearchResponse?,error:NSError?) in
                if error != nil {
                    println("Error occured in search: \(error!.localizedDescription)")
                } else if response!.mapItems.count == 0 {
                    println("No matches found")
                } else {
                    for item in response!.mapItems as! [MKMapItem] {
                        self.pointsOfInterest.append(item as MKMapItem)
                        
                        var annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = item.name
                        self.annotations.append(annotation);
                    }
                    self.tableView.reloadData()
                }
                
            }
            
            if !localSearch.searching{
                localSearch.startWithCompletionHandler(lSCompletionHandler)
            }
        }
    }

    func clear(){
        self.pointsOfInterest = []
        self.annotations = []
    }
        
    

    //get current userLocation
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
       
        if let newLocation = locations.last as? CLLocation{
            var center = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
            
            var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: Constants.latitudeDelta, longitudeDelta: Constants.longitudeDelta))
            
           // self.locationManager.stopUpdatingLocation()
            if self.usersLocationRegion == nil{
                userLocation = newLocation
            }
            self.usersLocationRegion = region as MKCoordinateRegion

            
        }

    }    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 10
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        // Configure the cell...
        cell.textLabel?.text = "test"
        //cell.textLabel?.text = self.pointsOfInterest[indexPath.row].name
        return cell
    }
    
    //MARK: - Searchbar Delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.pointsOfInterest = [];
        self.tableView.reloadData()

    }
    

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        searchForPointOfInterests(self.searchBar.text);
    }
    
}
