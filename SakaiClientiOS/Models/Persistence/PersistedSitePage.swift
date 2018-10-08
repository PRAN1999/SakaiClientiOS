//
//  PersistedSitePage.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 10/7/18.
//

import Foundation
import CoreData

@objc(PersistedSitePage) class PersistedSitePage: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var siteId: String
    @NSManaged var url: String

    init(from page: SitePage, entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        self.id = page.id
        self.title = page.title
        self.siteId = page.siteId
        self.url = page.url
    }
}
