//
//  Resource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/26/18.
//

import Foundation
import SwiftyJSON

/// A model for a Resource item in Sakai
struct ResourceItem {
    /// A model for the type of resource being represented
    ///
    /// - collection: A collection or folder of individual files or more collections. Contains the total size of the
    /// subtree
    /// - resource: An individual resource file
    enum ContentType {
        case collection(Int)
        case resource
    }

    let author: String?
    let title: String?
    let type: ContentType
    let url: String?
    let numChildren: Int

    /// Initialize a ResourceItem with available information
    ///
    /// - Parameters:
    ///   - author: The author/publisher of the ResourceItem
    ///   - title: The title/name of the ResourceItem
    ///   - type: The content type of the ResourceItem: .collection OR .resource
    ///   - url: The content url for the file
    ///   - numChildren: The number of direct children for a ResourceItem. Will be 0 if type is .resource
    init(_ author: String?,
         _ title: String?,
         _ type: ContentType,
         _ url: String?,
         _ numChildren: Int?) {
        self.author      = author
        self.title       = title
        self.type        = type
        self.url         = url
        self.numChildren = (numChildren != nil) ? numChildren! : 0
    }

    /// Initialize a ResourceItem from JSON object with corresponding data
    ///
    /// - Parameter data: The JSON object containing relevant ResourceItem information
    init(data: JSON) {
        let author      = data["author"].string
        let title       = data["title"].string
        let typeString  = data["type"].string
        let size        = data["size"].int
        let type        = (typeString == "collection" && size != nil) ? ContentType.collection(size!) : ContentType.resource
        let url         = data["url"].string
        let numChildren = data["numChildren"].int
        self.init(author, title, type, url, numChildren)
    }
}
