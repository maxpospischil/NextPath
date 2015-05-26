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
    
    @IBOutlet weak var trainZero: UITextView!
    @IBOutlet weak var trainOne: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        Data().destroyAll()
        //        Data().seed()
        //        Data().printFirstItem()
        
        trainZero.text = ""
        trainOne.text = ""
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.stringForKey("fromNJDefault") == nil {
            defaults.setObject("33rd Street", forKey: "fromNJDefault")
        }
        if defaults.stringArrayForKey("fromNYDefault") == nil {
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
                return
            }
            
            if placemarks.count > 0 {
                println(placemarks[0].locality)
                var nextTrains = Data().findCurrentTrains(manager.location, placemark: placemarks[0] as? CLPlacemark)
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
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        self.trainZero.text = "Having trouble locating you!"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

