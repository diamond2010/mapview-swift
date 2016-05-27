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


class TH_LocalSearchTableViewController: UITableViewController,CLLocationManagerDelegate,MKMapViewDelegate,UISearchBarDelegate, UISearchControllerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
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
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.delegate = self;
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
            self.searchBar.delegate = self
            self.searchBar.placeholder = "search here!"
        }else{
           let ctrl = UIAlertController(title: "no Services Available", message: "please make sure that you can use locationservices", preferredStyle:UIAlertControllerStyle.Alert)
        }
        
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
                        println("Name = \(item.name)")
                        println("Phone = \(item.phoneNumber)")
                        
                        self.pointsOfInterest.append(item as MKMapItem)
                        println("Matching items = \(self.pointsOfInterest.count)")
                        
                        var annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = item.name
                        self.annotations.append(annotation);
                        println("Annotations  = \(self.annotations.count)")
                        
                        
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
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        var center = CLLocationCoordinate2D(latitude: newLocation!.coordinate.latitude, longitude: newLocation!.coordinate.longitude)
        
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: Constants.latitudeDelta, longitudeDelta: Constants.longitudeDelta))
        
        self.locationManager.stopUpdatingLocation()
        if self.usersLocationRegion == nil{
            userLocation = newLocation
            self.usersLocationRegion = region as MKCoordinateRegion
        }
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return pointsOfInterest.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = self.pointsOfInterest[indexPath.row].name

        // Configure the cell...

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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.toMapIdentifier{
            if let mvc = segue.destinationViewController as? TH_ViewController{
                mvc.places = self.annotations as [MKAnnotation]
                mvc.usersLocation = userLocation
            }

        }
    }
}
