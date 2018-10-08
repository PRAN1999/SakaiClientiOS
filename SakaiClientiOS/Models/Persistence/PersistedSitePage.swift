//
//  PersistedSitePage.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 10/7/18.
//

import Foundation
import CoreData

@objc class PersistedSitePage: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var siteId: String
    @NSManaged var type: String
    @NSManaged var url: String
}
