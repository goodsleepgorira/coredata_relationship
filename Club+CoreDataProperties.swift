//
//  Club+CoreDataProperties.swift
//

import Foundation
import CoreData

extension Club {

    @NSManaged var clubName: String?
    @NSManaged var money: NSNumber?
    @NSManaged var place: String?
    @NSManaged var schedule: String?

}
