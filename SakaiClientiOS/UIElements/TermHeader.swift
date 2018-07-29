//
//  TermHeader.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/28/18.
//

import Foundation
import UIKit

/// The default section header to be used across the app to separate by Term in a HideableTableSource
class TermHeader : UITableViewHeaderFooterView , UIGestureRecognizerDelegate {
    
    static let reuseIdentifier: String = "termHeader"
    
    var titleLabel:UILabel!
    var imageLabel:UIImageView!
    var activityIndicator: UIActivityIndicatorView!
    var backgroundHeaderView: UIView!
    var tapRecognizer: UITapGestureRecognizer!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
        addViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        titleLabel = UILabel()
        titleLabel.font = UIFont.init(name: "Helvetica", size: 25.0)
        titleLabel.textColor = AppGlobals.SAKAI_RED
        
        imageLabel = UIImageView()
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = AppGlobals.SAKAI_RED
        
        tapRecognizer = UITapGestureRecognizer(target: nil, action: nil)
        tapRecognizer.delegate = self
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
    }
    
    func addViews() {
        self.addSubview(titleLabel)
        self.addSubview(imageLabel)
        self.addSubview(activityIndicator)
        self.backgroundView = backgroundHeaderView
        self.addGestureRecognizer(tapRecognizer)
    }
    
    func setConstraints() {
        let margins = self.layoutMarginsGuide
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        ///Constrain titleLabel to top, bottom and left edge of superview
        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: activityIndicator.leadingAnchor, constant: -20.0).isActive = true
        
        activityIndicator.topAnchor.constraint(lessThanOrEqualTo: margins.topAnchor, constant: 5.0).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        let constraint = NSLayoutConstraint(item: activityIndicator,
                                            attribute: .trailing,
                                            relatedBy: .lessThanOrEqual,
                                            toItem: imageLabel,
                                            attribute: .leading,
                                            multiplier: 1.0,
                                            constant: -20)
        constraint.priority = UILayoutPriority(999)
        self.addConstraint(constraint)
        
        //Constrain imageLabel to top, bottom, and right of superview
        imageLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        imageLabel.topAnchor.constraint(lessThanOrEqualTo: margins.topAnchor, constant: 5.0).isActive = true
        imageLabel.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor, constant: 5.0).isActive = true
        
    }
    
    
    /// Change the image of the header on tap to indicate a collapsed or expanded section
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
}
