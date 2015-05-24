//
//  Stops.swift
//  NextPath
//
//  Created by Maxwell Pospischil on 5/23/15.
//  Copyright (c) 2015 Maxwell Pospischil. All rights reserved.
//

import Foundation
import CoreData

class Stops: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var lat: NSNumber
    @NSManaged var lon: NSNumber
    @NSManaged var name: String

}
