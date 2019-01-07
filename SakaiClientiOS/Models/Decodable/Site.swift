//
//  Site.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/31/18.
//

import Foundation

/// A protocol for objects that can be sorted by Site and have a siteId
protocol SiteSortable {
    var siteId: String { get }
}

/// A model to represent a user Site object.
struct Site: TermSortable {
    let id: String
    let title: String
    let term: Term
    let description: String?
    let pages: [SitePage]
    let subjectCode: Int?
}

extension Site: Decodable {
    init(from decoder: Decoder) throws {
        let siteElement = try SiteElement(from: decoder)
        let id = siteElement.id
        let title = siteElement.title
        let description = siteElement.description
        let pages = siteElement.sitePages
        let term = Term(toParse: siteElement.props.termEid)
        var subjectCode: Int? = nil
        if let groupId = siteElement.providerGroupId {
            let courseCodeSplits = groupId.split(separator: "+")
            guard courseCodeSplits.count > 0 else {
                throw SakaiError.parseError("Could not find course code")
            }
            let subjectCodeSplits = courseCodeSplits[0].split(separator: ":")
            guard subjectCodeSplits.count > 3 else {
                throw SakaiError.parseError(
                    "Could not find subject code for course"
                )
            }
            guard let subjectCodeParsed = Int(String(subjectCodeSplits[3]))
                else {
                    throw SakaiError.parseError(
                        "Could not convert subject code into number"
                    )
            }
            subjectCode = subjectCodeParsed
        }

        self.init(id: id,
                  title: title,
                  term: term,
                  description: description,
                  pages: pages,
                  subjectCode: subjectCode)
    }

    init(from serializedSite: PersistedSite) {
        let id = serializedSite.id
        let title = serializedSite.title
        let description = serializedSite.siteDescription
        let term = Term(toParse: serializedSite.term)
        var pages: [SitePage] = []
        for page in serializedSite.sitePages {
            pages.append(SitePage(from: page))
        }
        let subjectCode = serializedSite.subjectCode
        self.init(id: id,
                  title: title,
                  term: term,
                  description: description,
                  pages: pages, subjectCode:
            subjectCode)
    }
}

extension Site {
    /// Sorts and splits an array of T:SiteSortable items by siteid and
    /// returns a [[T]] object where each sub-array represents the items for
    /// a specific Site
    ///
    /// - Parameter listToSort: The [T:SiteSortable] array that needs to be
    ///                         sorted by Site
    ///
    /// - Returns: A two-dimensional array of T split by siteId
    static func splitBySites<T: SiteSortable>(listToSort: [T]?) -> [[T]]? {
        guard let list = listToSort else {
            return nil
        }
        var sortedList: [[T]] = [[T]]()
        // Maintain a map of site Id's to array indices so items can be
        // added to the correct inner array. This is because Site's cannot
        // be compared like Terms, and therefore have to be split
        var mapSiteIdToIndex: [String: Int] = [:]
        var i: Int = 0
        let numItems: Int = list.count
        for index in 0..<numItems {
            let sortableItem: T = list[index]
            if let index = mapSiteIdToIndex[sortableItem.siteId] {
                // If the siteId exists in the dictionary, add the
                // SiteSortable item to the corresponding inner array
                sortedList[index].append(sortableItem)
            } else {
                // If the siteId does not exist in the dictionary, add it
                // to the dictionary and update the next open index count
                mapSiteIdToIndex.updateValue(i, forKey: sortableItem.siteId)
                sortedList.append([T]())
                sortedList[i].append(sortableItem)
                i += 1
            }
        }
        return sortedList
    }
}
