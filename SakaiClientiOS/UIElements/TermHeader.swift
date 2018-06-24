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
        setup()
        addViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        label = UILabel()
        label.font = UIFont.init(name: "Helvetica", size: 25.0)
        label.textColor = AppGlobals.SAKAI_RED
        
        backgroundHeaderView = UIView(frame: self.bounds)
        backgroundHeaderView.backgroundColor = UIColor.lightGray
        
        imageLabel = UIImageView()
        imageLabel.tintColor = UIColor.black
        
        tapRecognizer = UITapGestureRecognizer(target: nil, action: nil)
        tapRecognizer.delegate = self
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
    }
    
    func addViews() {
        self.addSubview(label)
        self.addSubview(imageLabel)
        self.backgroundView = backgroundHeaderView
        self.addGestureRecognizer(tapRecognizer)
    }
    
    func setupConstraints() {
        let margins = self.layoutMarginsGuide
        
        label.translatesAutoresizingMaskIntoConstraints = false
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        label.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        imageLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        imageLabel.topAnchor.constraint(lessThanOrEqualTo: margins.topAnchor, constant: 5.0).isActive = true
        imageLabel.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor, constant: 5.0).isActive = true
        
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
        imageLabel.layer.removeAllAnimations()
        if isHidden {
            imageLabel.image = UIImage(named: "show_content")
        } else {
            imageLabel.image = UIImage(named: "hide_content")
        }
    }
    
    func setTitle(title: String) {
        label.text = title
    }
}
