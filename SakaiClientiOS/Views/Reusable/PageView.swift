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
        scrollView = PageType()
    }

    func addViews() {
        self.addSubview(scrollView)
    }

    func setConstraints() {
        let margins = self.layoutMarginsGuide

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        // Constrain scrollView to top, right, and left anchors of view
        scrollView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
}
