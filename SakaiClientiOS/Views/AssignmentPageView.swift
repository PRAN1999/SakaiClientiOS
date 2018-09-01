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
    var scrollView: AssignmentDetailsView!

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
