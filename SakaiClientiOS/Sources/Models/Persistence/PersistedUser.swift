//
//  User.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 10/7/18.
//

import Foundation
import CoreData

@objc class PersistedUser: NSManagedObject {
    @NSManaged var userId: String
    @NSManaged var siteTitleMap: [String: String]
    @NSManaged var siteTermMap: [String: String]
    @NSManaged var siteAssignmentToolMap: [String: String]
    @NSManaged var termMap: [String: [String]]
    @NSManaged var termList: [String]
}
