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
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var trainZero: UITextView!
    @IBOutlet weak var trainOne: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        Data().destroyAll()
        //        Data().seed()
        //        Data().printFirstItem()
        
        trainZero.text = ""
        trainOne.text = ""
        if defaults.stringForKey("fromNJDefault") == nil {
            defaults.setObject("33rd Street", forKey: "fromNJDefault")
        }
        if defaults.stringForKey("fromNYDefault") == nil {
            defaults.setObject("Grove Street", forKey: "fromNYDefault")
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                self.tryLocationFromDefaults()
                return
            }
            
            if placemarks.count > 0 {
                let locality = placemarks[0].locality!
                self.defaults.setDouble(manager.location.coordinate.latitude, forKey: "lastLatitude")
                self.defaults.setDouble(manager.location.coordinate.longitude, forKey: "lastLongitude")
                self.defaults.setObject(locality, forKey: "locality")
                self.getNextTrainsAndUpdateUI(manager.location, locality: locality)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func getNextTrainsAndUpdateUI(currentLocation: CLLocation, locality: String) {
        var nextTrains = Data().findCurrentTrains(currentLocation, locality: locality)
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm" //format style. Browse online to get a format that fits your needs.
        if nextTrains.count > 0 {
            var dateString = dateFormatter.stringFromDate(nextTrains[0].time)
            self.trainZero.text = nextTrains[0].stop.name + " " + dateString + " " + nextTrains[0].trip.headSign
            dateString = dateFormatter.stringFromDate(nextTrains[1].time)
            self.trainOne.text = nextTrains[1].stop.name + " " + dateString + " " + nextTrains[1].trip.headSign
        } else {
            self.trainZero.text = "No trains to your default location from nearest path station"
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        tryLocationFromDefaults()
    }
    
    func tryLocationFromDefaults() {
        let latitude = defaults.doubleForKey("lastLatitude")
        let longitude = defaults.doubleForKey("lastLongitude")
        let locality = defaults.stringForKey("locality")
        if defaults.stringForKey("locality") == nil {
            trainZero.text = "Having trouble locating you!"
        } else {
            let location = CLLocation(latitude: latitude, longitude: longitude)
            getNextTrainsAndUpdateUI(location, locality: locality!)
        }
    }
    
    
}

