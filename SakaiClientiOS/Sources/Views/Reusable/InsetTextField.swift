//
//  InsetTextField.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/15/19.
//

import Foundation
import UIKit

class InsetTextField: UITextField {
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
}
