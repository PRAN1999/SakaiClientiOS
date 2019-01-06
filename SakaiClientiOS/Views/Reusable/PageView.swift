//
//  PageView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/18/18.
//

import UIKit

/// A full page scrollview
class PageView<PageType: UIScrollView>: UIView {

    let scrollView: PageType = UIView.defaultAutoLayoutView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(scrollView)
    }

    private func setConstraints() {
        scrollView.constrainToMargins(of: self, onSides: [.top, .bottom])
        scrollView.constrainToEdges(of: self, onSides: [.left, .right])
    }
}
