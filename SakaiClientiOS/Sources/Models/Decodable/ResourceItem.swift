//
//  ResourceItem.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/26/18.
//

import Foundation

/// A model for a Resource item in Sakai
struct ResourceItem {

    /// A model for the type of resource being represented
    ///
    /// - collection: A collection or folder of individual files or more
    ///               collections. Contains the total size of the subtree
    /// - resource: An individual resource file
    enum ContentType {
        case collection(Int)
        case resource
    }

    let author: String?
    let title: String?
    let level: Int
    let type: ContentType
    let url: String?
    let numChildren: Int
}

extension ResourceItem: Decodable {
    init(from decoder: Decoder) throws {
        let resourceItemElement = try ResourceItemElement(from: decoder)
        let typeString = resourceItemElement.typeString
        let size = resourceItemElement.size
        let author = resourceItemElement.author
        let title = resourceItemElement.title
        let container = resourceItemElement.container
        let splitContainer = container.split(separator: "/")
        let level = splitContainer.count - 3
        let url = resourceItemElement.url
        let numChildren = resourceItemElement.numChildren != nil ? resourceItemElement.numChildren! : 0
        let type = (typeString == "collection" && size != nil) ?
            ContentType.collection(size!) : ContentType.resource

        self.init(author: author,
                  title: title,
                  level: level,
                  type: type,
                  url: url,
                  numChildren: numChildren)
    }
}
