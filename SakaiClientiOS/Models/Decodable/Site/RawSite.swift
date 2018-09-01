//
//  SiteCollectionRaw.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/31/18.
//

import Foundation

struct SiteCollection: Decodable {
    let siteCollection: [Site]

    enum CodingKeys: String, CodingKey {
        case siteCollection = "site_collection"
    }
}

struct SiteElement: Decodable {
    let id: String
    let title: String
    let props: Props
    let description: String?
    let sitePages: [SitePage]
}

struct Props: Decodable {
    let termEid: String?

    enum CodingKeys: String, CodingKey {
        case termEid = "term_eid"
    }
}
