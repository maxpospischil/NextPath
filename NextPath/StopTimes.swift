//
//  StopTimes.swift
//  NextPath
//
//  Created by Maxwell Pospischil on 5/24/15.
//  Copyright (c) 2015 Maxwell Pospischil. All rights reserved.
//

import Foundation
import CoreData

class StopTimes: NSManagedObject {

    @NSManaged var time: NSDate
    @NSManaged var stop: Stops
    @NSManaged var trip: Trips

}
