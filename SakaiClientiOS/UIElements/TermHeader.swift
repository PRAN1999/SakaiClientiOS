//
//  TermHeader.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/28/18.
//

import Foundation
import UIKit

/// The default section header to be used across the app to divide by Term in CollapsibleSectionController
class TermHeader : UITableViewHeaderFooterView , UIGestureRecognizerDelegate {
    
    static let reuseIdentifier: String = "termHeader"
    
    ///The label holding the text
    var titleLabel:UILabel!
    
    ///The label holding the arrow indicator
    var imageLabel:UIImageView!
    
    ///The background for the view
    var backgroundHeaderView: UIView!
    
    ///A gesture recognizer to catch taps
    var tapRecognizer: UITapGestureRecognizer!
    
    ///Sets up subviews, adds them to self, adds constraints
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
        addViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /// Initializes and sets non-constraint attributes of subviews
    func setup() {
        titleLabel = UILabel()
        titleLabel.font = UIFont.init(name: "Helvetica", size: 25.0)
        titleLabel.textColor = AppGlobals.SAKAI_RED
        
        imageLabel = UIImageView()
        
        //Initialize gesture recognizer and set attributes
        tapRecognizer = UITapGestureRecognizer(target: nil, action: nil)
        tapRecognizer.delegate = self
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
    }
    
    
    /// Add subviews to self and set background view
    func addViews() {
        self.addSubview(titleLabel)
        self.addSubview(imageLabel)
        self.backgroundView = backgroundHeaderView
        self.addGestureRecognizer(tapRecognizer)
    }
    
    
    /// Set subview constraints between titleLabel and imageLabel. The titleLabel will cover the left side of the view while the imageLabel will take over the right side
    func setupConstraints() {
        let margins = self.layoutMarginsGuide
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        ///Constrain titleLabel to top, bottom and left edge of superview
        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        //Constrain imageLabel to top, bottom, and right of superview
        imageLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        imageLabel.topAnchor.constraint(lessThanOrEqualTo: margins.topAnchor, constant: 5.0).isActive = true
        imageLabel.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor, constant: 5.0).isActive = true
        
        //Constrain the trailing anchor of the titleLable to be less than or equal to the leading anchor of the imageLabel
        let constraint = NSLayoutConstraint(item: titleLabel,
                                           attribute: .trailing,
                                           relatedBy: .lessThanOrEqual,
                                           toItem: imageLabel,
                                           attribute: .leading,
                                           multiplier: 1.0,
                                           constant: 0.0)
        constraint.priority = UILayoutPriority(rawValue: 999) //lower the priority to ensure constraints can be overridden
        self.addConstraint(constraint)
    }
    
    
    /// Change the image of the header on tap
    ///
    /// - Parameter isHidden: A variable to determine which image should be shown based on whether the section is hidden or open
    func setImage(isHidden: Bool) {
        imageLabel.layer.removeAllAnimations()
        if isHidden {
            imageLabel.image = UIImage(named: "show_content")
        } else {
            imageLabel.image = UIImage(named: "hide_content")
        }
    }
    
    
    /// Set the text of the titleLabel
    ///
    /// - Parameter title: a String title to assign to the titleLabel.text
    func setTitle(title: String) {
        titleLabel.text = title
    }
}
