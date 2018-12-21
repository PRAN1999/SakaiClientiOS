//
//  UITableViewCellExtension.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 12/21/18.
//

import Foundation
import UIKit

extension UITableViewCell {
    func darkSelectedView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.color(withTransparency: 0.5)
        return view
    }
}
