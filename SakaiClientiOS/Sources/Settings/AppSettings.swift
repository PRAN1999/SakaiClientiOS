//
//  AppSettings.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/12/19.
//

import Foundation

enum AppSettings: CaseIterable {
    case about, privacy, thanks, contact, rate

    var description: String {
        switch self {
        case .about:
            return "About"
        case .privacy:
            return "Privacy Policy"
        case .thanks:
            return "Thanks To"
        case .contact:
            return "Contact Us"
        case .rate:
            return "Rate Rutgers Sakai Mobile"
        }
    }

    var icon: String? {
        switch self {
        case .about:
            return AppIcons.infoIcon
        case .privacy:
            return AppIcons.privacyIcon
        case .thanks:
            return AppIcons.thanksIcon
        case .contact:
            return AppIcons.contactIcon
        case .rate:
            return AppIcons.rateIcon
        }
    }
}
