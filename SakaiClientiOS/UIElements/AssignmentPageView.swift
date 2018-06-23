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
        self.scrollView = AssignmentDetailsView(frame: self.bounds)
        
        self.titleLabel = InsetUILabel()
        self.titleLabel.backgroundColor = AppGlobals.SAKAI_RED
        self.titleLabel.titleLabel.numberOfLines = 0
        self.titleLabel.titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.titleLabel.titleLabel.textAlignment = .center
        self.titleLabel.titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        self.titleLabel.layer.cornerRadius = 0
        
        self.headerView = UIView()
        self.headerView.backgroundColor = UIColor.black
        
        self.scrollView.contentSize = CGSize(width: self.frame.width, height: 1000)
    }
    
    func addViews() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.scrollView)
        self.addSubview(self.headerView)
    }
    
    func setConstraints() {
        let margins = self.layoutMarginsGuide
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.15).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        
        self.headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.headerView.bottomAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        
        self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true        
    }
}
