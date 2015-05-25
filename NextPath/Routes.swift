//
//  Routes.swift
//  NextPath
//
//  Created by Maxwell Pospischil on 5/24/15.
//  Copyright (c) 2015 Maxwell Pospischil. All rights reserved.
//

import Foundation
import CoreData

class Routes: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var trips: NSSet

}
