//
//  PersistedSite.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 10/7/18.
//

import Foundation
import CoreData

@objc class PersistedSite: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var term: String
    @NSManaged var siteDescription: String?
    @NSManaged var sitePages: [PersistedSitePage]
}
