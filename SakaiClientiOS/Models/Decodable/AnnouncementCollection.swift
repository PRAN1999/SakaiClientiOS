//
//  RawAnnouncement.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/31/18.
//

import Foundation

struct AnnouncementCollection: Decodable {
    let announcementCollection: [Announcement]

    enum CodingKeys: String, CodingKey {
        case announcementCollection = "announcement_collection"
    }
}
