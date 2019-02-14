//
//  Parsing.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/28/18.
//

import Foundation
import UIKit

extension String {
    /// Converts HTML string to a `NSAttributedString` with HTML markup
    var htmlAttributedString: NSAttributedString? {
        return try?
            NSAttributedString(data: Data(utf8),
                               options: [.documentType: NSAttributedString.DocumentType.html,
                                         .characterEncoding: String.Encoding.utf8.rawValue],
                               documentAttributes: nil)
    }

    static func getDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "M/d/yy"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"

        let calendar = Calendar(identifier: .gregorian)
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "hh:mm a"
            return formatter.string(from: date)
        }
        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }

        var dateComponent = DateComponents()
        dateComponent.day = -7
        let current = Date()
        if
            let weekAgo = calendar.date(byAdding: dateComponent, to: current),
            let yearAgo = calendar.date(byAdding: .year, value: -1, to: current) {
            if date > weekAgo {
                return getDayString(weekday: calendar.component(.weekday, from: date))
            } else if date > yearAgo {
                formatter.dateFormat = "MMM d"
                return formatter.string(from: date)
            }
        }
        return formatter.string(from: date)
    }

    static func getDayString(weekday: Int) -> String {
        switch weekday {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return ""
        }
    }
}

extension NSAttributedString {
    var html: String {
        do {
            let oldData = try data(from: NSRange(location: 0, length: length),
                                   documentAttributes: [NSAttributedString.DocumentAttributeKey.documentType : NSAttributedString.DocumentType.html])

            //Convert the UTF-8 data to a string, display it in the text view
            //Original HTML Old String
            return String(data: oldData, encoding: .utf8)!
        } catch {
            //I hate catch blocks :|
            return string
        }
    }
}
