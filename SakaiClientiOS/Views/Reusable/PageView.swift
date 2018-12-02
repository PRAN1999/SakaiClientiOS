//
//  PageView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/18/18.
//

import UIKit

/// A full page scrollview
class PageView<PageType: UIScrollView>: UIView {

    var scrollView: PageType!
    
    var shouldSetConstraints = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        if shouldSetConstraints {
            setConstraints()
            shouldSetConstraints = false
        }
        super.updateConstraints()
    }

    func setup() {
        scrollView = PageType()

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        setNeedsUpdateConstraints()
    }

    func addViews() {
        self.addSubview(scrollView)
    }

    func setConstraints() {
        let margins = self.layoutMarginsGuide
        
        scrollView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
}
