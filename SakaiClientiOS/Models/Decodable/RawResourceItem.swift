//
//  RawResourceItem.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/31/18.
//

import Foundation

struct ResourceCollection: Decodable {
    let contentCollection: [ResourceItem]

    enum CodingKeys: String, CodingKey {
        case contentCollection = "content_collection"
    }
}

struct ResourceItemElement: Decodable {
    let author: String
    let title: String
    let typeString: String?
    let size: Int?
    let url: String?
    let numChildren: Int?

    enum CodingKeys: String, CodingKey {
        case author, title
        case typeString = "type"
        case size, url, numChildren
    }
}
