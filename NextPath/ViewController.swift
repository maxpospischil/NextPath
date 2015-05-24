//
//  ViewController.swift
//  NextPath
//
//  Created by Maxwell Pospischil on 5/23/15.
//  Copyright (c) 2015 Maxwell Pospischil. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    let locationManager = CLLocationManager()
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    @IBOutlet weak var addressTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            addressTextField.text = locality + " " + postalCode + " " + administrativeArea + " " + country
            addressTextField.editable = false
            println(locality)
            println(postalCode)
            println(administrativeArea)
            println(country)
//            parseCSV()
            printFirstItem()
        }
        
    }
    
    func parseCSV() {
        var csv: CSV!
        var csvWithCRLF: CSV!
        var csvWithManualHeaders: CSV!
        var error: NSErrorPointer = nil
        let csvURL = NSBundle(forClass: ViewController.self).URLForResource("stops", withExtension: "csv")
        csv = CSV(contentsOfURL: csvURL!, error: error)
        for item in csv.rows {
            let newStop = NSEntityDescription.insertNewObjectForEntityForName("Stops", inManagedObjectContext: self.managedObjectContext!) as! Stops
            newStop.id = item["stop_id"]!.toInt()!
            newStop.name = item["stop_name"]!
        }
        managedObjectContext!.save(nil)
        
    }
    
    func printFirstItem() {
        // Create a new fetch request using the LogItem entity
        let fetchRequest = NSFetchRequest(entityName: "Stops")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Stops] {
            
            println(fetchResults[0])
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

