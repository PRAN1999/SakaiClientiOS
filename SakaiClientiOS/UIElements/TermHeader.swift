//
//  TermHeader.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/28/18.
//

import Foundation
import UIKit

class TermHeader : UITableViewHeaderFooterView , UIGestureRecognizerDelegate {
    
    static let reuseIdentifier: String = "termHeader"
    
    var label:UILabel!
    var imageLabel:UIImageView!
    var backgroundHeaderView: UIView!
    var tapRecognizer: UITapGestureRecognizer!
    
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
        self.label.font = UIFont.init(name: "Helvetica", size: 25.0)
        self.label.textColor = UIColor(red: 199 / 255.0, green: 37 / 255.0, blue: 78 / 255.0, alpha: 1.0)
        
        self.backgroundHeaderView = UIView(frame: self.bounds)
        self.backgroundHeaderView.backgroundColor = UIColor.lightGray
        
        self.imageLabel = UIImageView()
        self.imageLabel.tintColor = UIColor.black
        
        self.tapRecognizer = UITapGestureRecognizer(target: nil, action: nil)
        self.tapRecognizer.delegate = self
        self.tapRecognizer.numberOfTapsRequired = 1
        self.tapRecognizer.numberOfTouchesRequired = 1
    }
    
    func addViews() {
        self.addSubview(label)
        self.addSubview(imageLabel)
        self.backgroundView = backgroundHeaderView
        self.addGestureRecognizer(tapRecognizer)
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
        self.imageLabel.layer.removeAllAnimations()
        if isHidden {
            self.imageLabel.image = UIImage(named: "show_content")
        } else {
            self.imageLabel.image = UIImage(named: "hide_content")
        }
    }
    
    func setTitle(title: String) {
        self.label.text = title
    }
}
