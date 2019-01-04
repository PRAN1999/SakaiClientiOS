//
//  SiteElement.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/30/18.
//

import Foundation

struct SiteElement: Decodable {
    let id: String
    let title: String
    let props: Props
    let description: String?
    let sitePages: [SitePage]
    let providerGroupId: String?
}

struct Props: Decodable {
    let termEid: String?

    enum CodingKeys: String, CodingKey {
        case termEid = "term_eid"
    }
}
