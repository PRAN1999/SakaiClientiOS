//
//  UIButtonExtension.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/5/19.
//

import Foundation
import UIKit

extension UIButton {
    static func roundButton(button: UIButton) {

        button.backgroundColor = Palette.main.highlightColor
        button.titleLabel?.textColor = Palette.main.primaryTextColor

        button.layer.cornerRadius = 10
        button.layer.borderColor = Palette.main.borderColor.cgColor
        button.layer.borderWidth = 1
        button.layer.masksToBounds = false
    }
}
