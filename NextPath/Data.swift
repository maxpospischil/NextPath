//
//  PopulateData.swift
//  NextPath
//
//  Created by Maxwell Pospischil on 5/24/15.
//  Copyright (c) 2015 Maxwell Pospischil. All rights reserved.
//

import UIKit
import Foundation
import CoreData

public class Data {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func seed() {
        populateRoutes()
        populateTrips()
        populateStops()
        populateStopTimes()
    }
    
    func destroyAll() {
        deleteAllRoutes()
        deleteAllTrips()
        deleteAllStops()
        deleteAllStopTimes()
    }
    
    func findCurrentTrains() {
        
    }
    
    
    func populateRoutes() {
        var csv: CSV!
        var csvWithCRLF: CSV!
        var csvWithManualHeaders: CSV!
        var error: NSErrorPointer = nil
        let csvURL = NSBundle(forClass: ViewController.self).URLForResource("routes", withExtension: "csv")
        csv = CSV(contentsOfURL: csvURL!, error: error)
        for item in csv.rows {
            let newRoute = NSEntityDescription.insertNewObjectForEntityForName("Routes", inManagedObjectContext: self.managedObjectContext!) as! Routes
            newRoute.id = item["route_id"]!.toInt()!
            newRoute.name = item["route_long_name"]!
        }
        managedObjectContext!.save(nil)
    }
    
    func populateTrips() {
        var csv: CSV!
        var csvWithCRLF: CSV!
        var csvWithManualHeaders: CSV!
        var error: NSErrorPointer = nil
        let csvURL = NSBundle(forClass: ViewController.self).URLForResource("trips", withExtension: "csv")
        csv = CSV(contentsOfURL: csvURL!, error: error)
        for item in csv.rows {
            let newTrip = NSEntityDescription.insertNewObjectForEntityForName("Trips", inManagedObjectContext: self.managedObjectContext!) as! Trips
            var serviceId = item["service_id"]!
            if serviceId == "1602A2876" {
                newTrip.serviceType = "weekday"
            } else if serviceId == "1603A2876"{
                newTrip.serviceType = "saturday"
            } else if serviceId == "1604A2876" {
                newTrip.serviceType = "sunday"
            }
            newTrip.tripId = item["trip_id"]!
            newTrip.headSign = item["trip_headsign"]!
            
            var request = NSFetchRequest(entityName: "Routes")
            request.returnsObjectsAsFaults = false;
            var single = NSPredicate(format: "id = %i", item["route_id"]!.toInt()!)
            request.predicate = single
            var results:NSArray = managedObjectContext!.executeFetchRequest(request, error: nil)!
            newTrip.route = results[0] as! Routes
        }
        managedObjectContext!.save(nil)
    }
    
    func populateStops() {
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
            newStop.lat = (item["stop_lat"]! as NSString).doubleValue
            newStop.lon = (item["stop_lon"]! as NSString).doubleValue
        }
        managedObjectContext!.save(nil)
        
    }
    
    func populateStopTimes() {
        var csv: CSV!
        var csvWithCRLF: CSV!
        var csvWithManualHeaders: CSV!
        var error: NSErrorPointer = nil
        let csvURL = NSBundle(forClass: ViewController.self).URLForResource("stop_times", withExtension: "csv")
        csv = CSV(contentsOfURL: csvURL!, error: error)
        let fetchRequest = NSFetchRequest(entityName: "Trips")
        var trips = [String: Trips]()
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Trips] {
            for trip in fetchResults{
                trips[trip.tripId] = trip
            }
        }
        
        for item in csv.rows {
            var dateString = item["departure_time"]! // change to your date format
            
            if (dateString as NSString).substringToIndex(2) == "24" {
                dateString = "00" + (dateString as NSString).substringFromIndex(2)
            }
            
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            
            var date = dateFormatter.dateFromString(dateString)
            
            let newStopTime = NSEntityDescription.insertNewObjectForEntityForName("StopTimes", inManagedObjectContext: self.managedObjectContext!) as! StopTimes
            
            newStopTime.time = date!
            
            var request = NSFetchRequest(entityName: "Stops")
            request.returnsObjectsAsFaults = false;
            var single = NSPredicate(format: "id = %i", item["stop_id"]!.toInt()!)
            request.predicate = single
            var results:NSArray = managedObjectContext!.executeFetchRequest(request, error: nil)!
            
            newStopTime.stop = results[0] as! Stops
            
            newStopTime.trip = trips[item["trip_id"]!]!
            
        }
        managedObjectContext!.save(nil)
        
    }
    
    func deleteAllStops() {
        let fetchRequest = NSFetchRequest(entityName: "Stops")
        let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [Stops]
        
        for item in fetchResults {
            managedObjectContext!.deleteObject(item as NSManagedObject)
        }
        
        managedObjectContext!.save(nil)
    }
    
    func deleteAllRoutes() {
        let fetchRequest = NSFetchRequest(entityName: "Routes")
        let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [Routes]
        
        for item in fetchResults {
            managedObjectContext!.deleteObject(item as NSManagedObject)
        }
        
        managedObjectContext!.save(nil)
    }
    
    func deleteAllStopTimes() {
        let fetchRequest = NSFetchRequest(entityName: "StopTimes")
        let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [StopTimes]
        
        for item in fetchResults {
            managedObjectContext!.deleteObject(item as NSManagedObject)
        }
        
        managedObjectContext!.save(nil)
    }
    
    func deleteAllTrips() {
        let fetchRequest = NSFetchRequest(entityName: "Trips")
        let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [Trips]
        
        for item in fetchResults {
            managedObjectContext!.deleteObject(item as NSManagedObject)
        }
        
        managedObjectContext!.save(nil)
    }
    
    func printFirstItem() {
        let fetchRequest = NSFetchRequest(entityName: "Trips")
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Trips] {
            
            println(fetchResults[3].stops.count)
        }
    }
}