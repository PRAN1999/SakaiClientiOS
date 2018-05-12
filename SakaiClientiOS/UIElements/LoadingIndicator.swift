//
//  LoadingIndicator.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/12/18.
//

import UIKit

class LoadingIndicator: UIActivityIndicatorView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.color = UIColor.black
        self.backgroundColor = UIColor.white
    }
    
    convenience init(frame: CGRect, view: UITableView) {
        self.init(frame: frame)
        self.center = CGPoint(x: view.center.x, y: view.center.y - 80)
        view.addSubview(self)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
