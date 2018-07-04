//
//  AssignmentPageView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/18/18.
//

import UIKit

class AssignmentPageView: UIView {
    
    var scrollView:AssignmentDetailsView!
    var titleLabel:InsetUILabel!
    var pageControl:UIPageControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        scrollView = AssignmentDetailsView()
        
        titleLabel = InsetUILabel()
        titleLabel.backgroundColor = AppGlobals.SAKAI_RED
        titleLabel.titleLabel.numberOfLines = 0
        titleLabel.titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.titleLabel.textAlignment = .center
        titleLabel.titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabel.layer.cornerRadius = 0
        
        pageControl = UIPageControl()
        pageControl.currentPage = 1
        pageControl.numberOfPages = 10
        pageControl.pageIndicatorTintColor = AppGlobals.SAKAI_RED
        pageControl.backgroundColor = UIColor.black
        pageControl.currentPageIndicatorTintColor = UIColor.white
    }
    
    func addViews() {
        self.addSubview(titleLabel)
        self.addSubview(scrollView)
    }
    
    func setConstraints() {
        let margins = self.layoutMarginsGuide
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentInset = UIEdgeInsets(top: titleLabel.bounds.size.height - 7, left: 0, bottom: 0, right: 0)
    }
}
