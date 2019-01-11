//
//  UIColorExtension.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/21/18.
//

import Foundation
import UIKit

extension UIColor {
   func rgb() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            return (red:fRed, green:fGreen, blue:fBlue, alpha:fAlpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }

    func color(withTransparency alpha: CGFloat) -> UIColor {
        guard let rgb = rgb() else {
            return self
        }
        let bColor = UIColor(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: alpha)
        return bColor
    }
}
