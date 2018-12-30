//
//  ResourceItemElement.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/30/18.
//

import Foundation

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
