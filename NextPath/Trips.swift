//
//  Trips.swift
//  NextPath
//
//  Created by Maxwell Pospischil on 5/24/15.
//  Copyright (c) 2015 Maxwell Pospischil. All rights reserved.
//

import Foundation
import CoreData

class Trips: NSManagedObject {

    @NSManaged var tripId: String
    @NSManaged var serviceType: String
    @NSManaged var headSign: String
    @NSManaged var route: Routes
    @NSManaged var stops: NSSet

}
