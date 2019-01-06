//
//  AppIcons.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/3/19.
//

import Foundation

final class AppIcons {

    static let assignmentsIcon = "\u{F100}"
    static let gradebookIcon = "\u{F101}"
    static let announcementsIcon = "\u{F102}"
    static let statusOpenIcon = "\u{F116}"
    static let dateIcon = "\u{F10A}"
    static let criticalIcon = "\u{F10B}"
    static let maxGradeIcon = "\u{F115}"
    static let infoIcon = "\u{F10D}"
    static let attachmentIcon = "\u{F10E}"
    static let slideUpIcon = "\u{F10F}"
    static let resourcesIcon = "\u{F110}"
    static let chatIcon = "\u{F111}"
    static let dueIcon = "\u{F112}"
    static let resubmitIcon = "\u{F113}"
    static let closedStatusIcon = "\u{F114}"
    static let privacyIcon = "\u{F117}"
    static let thanksIcon = "\u{F118}"
    static let contactIcon = "\u{F119}"

    static let generalIconFont = "General-Icons"
    static let siteFont = "iOS-Icons"
    private static let siteIconsFile = "site-icons"

    static let codeToIcon: [Int: String] = {
        var codeToIcon: [Int: String] = [:]

        if let filepath = Bundle.main.path(forResource: AppIcons.siteIconsFile, ofType: "json") {
            do {
                let url = URL(fileURLWithPath: filepath)
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let iconConfig = try decoder.decode(IconConfiguration.self, from: data)
                for icon in iconConfig.icons {
                    guard let unicodeInt = Int(icon.hex, radix: 16),
                        let scalar = UnicodeScalar(unicodeInt) else {
                        continue
                    }
                    let character = Character(scalar)
                    guard let code = Int(icon.subjectCode) else {
                        continue
                    }
                    codeToIcon.updateValue(String(character), forKey: code)
                }
            } catch let err {
                print(err)
            }
        } else {
            print("icons.json not found")
        }
        return codeToIcon
    }()
}
