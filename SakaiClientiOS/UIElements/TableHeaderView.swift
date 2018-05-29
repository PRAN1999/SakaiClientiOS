//
//  TableViewHeaderView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/28/18.
//

import Foundation
import UIKit

class TableHeaderView : UITableViewHeaderFooterView {
    
    static var reuseIdentifier: String = "tableHeaderView"
    
    var label:UILabel!
    var imageLabel:UIImageView!
    var backgroundHeaderView: UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setup()
        self.addViews()
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        self.label = UILabel()
        self.imageLabel = UIImageView()
        self.backgroundHeaderView = UIView(frame: self.bounds)
        
        self.backgroundHeaderView.backgroundColor = UIColor.lightGray
        
        self.label.font = UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.heavy)
        self.label.textColor = UIColor.red
        
        self.imageLabel.tintColor = UIColor.black
    }
    
    func addViews() {
        self.addSubview(label)
        self.addSubview(imageLabel)
        self.backgroundView = backgroundHeaderView
    }
    
    func setupConstraints() {
        let margins = self.layoutMarginsGuide
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.imageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.label.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.label.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        //self.label.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1.0).isActive = true
        
        self.imageLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        self.addConstraint(NSLayoutConstraint(item: self.imageLabel,
                                              attribute: .top,
                                              relatedBy: .lessThanOrEqual,
                                              toItem: margins,
                                              attribute: .top,
                                              multiplier: 1.0,
                                              constant: 5.0))
        
        self.addConstraint(NSLayoutConstraint(item: self.imageLabel,
                                              attribute: .bottom,
                                              relatedBy: .lessThanOrEqual,
                                              toItem: margins,
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: 5.0))
        
        let constraint = NSLayoutConstraint(item: label,
                                           attribute: .trailing,
                                           relatedBy: .lessThanOrEqual,
                                           toItem: imageLabel,
                                           attribute: .leading,
                                           multiplier: 1.0,
                                           constant: 0.0)
        constraint.priority = UILayoutPriority(rawValue: 999)
        self.addConstraint(constraint)
    }
    
    func setImage(isHidden: Bool) {
        if isHidden {
            self.imageLabel.image = UIImage(named: "show_content")
        } else {
            self.imageLabel.image = UIImage(named: "hide_content")
        }
        
    }
    
    func rotateImage(isHidden: Bool) {
        let rotation: Float
        if !isHidden {
            rotation = 1
        } else {
            rotation = -1
        }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = Float.pi * rotation
        animation.duration = 0.3
        animation.repeatCount = 1
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        
        self.imageLabel.layer.add(animation, forKey: nil)
    }
    
}
