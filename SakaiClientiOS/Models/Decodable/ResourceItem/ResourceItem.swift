//
//  Resource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/26/18.
//

import Foundation

/// A model for a Resource item in Sakai
struct ResourceItem: Decodable {

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

    init(from decoder: Decoder) throws {
        let resourceItemElement = try ResourceItemElement(from: decoder)
        self.author = resourceItemElement.author
        self.title = resourceItemElement.title
        let typeString = resourceItemElement.typeString
        let size = resourceItemElement.size
        self.url = resourceItemElement.url
        self.numChildren = resourceItemElement.numChildren != nil ? resourceItemElement.numChildren! : 0
        self.type = (typeString == "collection" && size != nil) ? ContentType.collection(size!) : ContentType.resource
    }

}
