//
//  NavigationController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/2/19.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = Palette.main.navigationTintColor
        navigationBar.barStyle = Palette.main.barStyle
        navigationBar.titleTextAttributes?.updateValue(Palette.main.navigationTitleColor, forKey: .foregroundColor)
        //navigationBar.isTranslucent = true
    }

}
