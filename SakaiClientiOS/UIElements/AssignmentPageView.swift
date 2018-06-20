//
//  AssignmentPageView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/18/18.
//

import UIKit

class AssignmentPageView: UIView {
    
    var scrollView:UIScrollView!
    var titleLabel:InsetUILabel!
    var headerView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.addViews()
        self.setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.titleLabel = InsetUILabel()
        self.titleLabel.backgroundColor = UIColor(red: 199 / 255.0, green: 37 / 255.0, blue: 78 / 255.0, alpha: 1.0)
        
        self.titleLabel.titleLabel.numberOfLines = 0
        self.titleLabel.titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.titleLabel.titleLabel.textAlignment = .center
        self.titleLabel.titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        self.headerView = UIView()
        self.headerView.backgroundColor = UIColor.black
    }
    
    func addViews() {
        self.addSubview(titleLabel)
        self.addSubview(headerView)
    }
    
    func setConstraints() {
        let margins = self.layoutMarginsGuide
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.15).isActive = true
        
        self.headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        self.addConstraint(NSLayoutConstraint(item: self.headerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: margins,
                                              attribute: .top,
                                              multiplier: 1.0,
                                              constant: 0.0))
        
    }

}
