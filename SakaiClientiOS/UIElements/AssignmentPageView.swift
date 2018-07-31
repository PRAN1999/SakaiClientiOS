//
//  AssignmentPageView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/18/18.
//

import UIKit

/// The full page view to show an Assignment object
class AssignmentPageView: UIView {
    
    /// A scrollView containing all the relevant Assignment information
    var scrollView:AssignmentDetailsView!
    var titleLabel:InsetUILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Instantiate and configure subviews
    func setup() {
        scrollView = AssignmentDetailsView()
        
        titleLabel = InsetUILabel()
        titleLabel.backgroundColor = AppGlobals.SAKAI_RED
        titleLabel.titleLabel.numberOfLines = 0
        titleLabel.titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.titleLabel.textAlignment = .center
        titleLabel.titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabel.layer.cornerRadius = 0
    }
    
    func addViews() {
        self.addSubview(titleLabel)
        self.addSubview(scrollView)
    }
    
    func setConstraints() {
        let margins = self.layoutMarginsGuide
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constrain titleLabel to top, right, and left anchors of view
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        // Constrain titleLabel height to be 12% of view height
        titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12).isActive = true

        titleLabel.bottomAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set the content inset to account for the static titleLabel being above the scroll view
        scrollView.contentInset = UIEdgeInsets(top: titleLabel.bounds.size.height - 7, left: 0, bottom: 0, right: 0)
    }
}
