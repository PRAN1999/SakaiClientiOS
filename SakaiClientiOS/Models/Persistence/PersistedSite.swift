//
//  PersistedSite.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 10/7/18.
//

import Foundation
import CoreData

@objc(PersistedSite) class PersistedSite: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var term: String?
    @NSManaged var siteDescription: String?
    @NSManaged var sitePages: [PersistedSitePage]

    func setData(from site: Site, in context: NSManagedObjectContext) {
        self.id = site.id
        self.title = site.title
        self.term = site.term.initString
        self.siteDescription = site.description
        for page in site.pages {
            let persistedPage = PersistedSitePage(from: page, entity: NSEntityDescription.entity(forEntityName: "PersistedSitePage", in: context)!, insertInto: context)
            self.sitePages.append(persistedPage)
        }
    }
}
