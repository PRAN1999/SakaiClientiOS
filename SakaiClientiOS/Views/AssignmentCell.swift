//
//  AssignmentCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/10/18.
//

import UIKit
import ReusableSource

/// A CollectionViewCell to represent an Assignment model
class AssignmentCell: UICollectionViewCell, ConfigurableCell {
    // swiftlint:disable type_name
    typealias T = Assignment

    var titleLabel: InsetUILabel!
    var dueLabel: InsetUILabel!
    var descLabel: UITextView!

    /// Since the textView has its own recognizers, a tap on the textView will not register as a cell selection
    ///
    /// The tapRecognizer forwards the taps to the UICollectionViewDelegate
    var tapRecognizer: IndexRecognizer!

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
        titleLabel = InsetUILabel()
        dueLabel = InsetUILabel()
        descLabel = UITextView()

        titleLabel.titleLabel.font = UIFont.boldSystemFont(ofSize: 11.0)
        dueLabel.titleLabel.font = UIFont.boldSystemFont(ofSize: 10.7)

        descLabel.isEditable = false
        descLabel.isSelectable = true
        descLabel.backgroundColor = UIColor.white

        tapRecognizer = IndexRecognizer(target: nil, action: nil)
        tapRecognizer.cancelsTouchesInView = false

        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = false
    }

    func addViews() {
        self.addSubview(titleLabel)
        self.addSubview(dueLabel)
        self.addSubview(descLabel)
        descLabel.addGestureRecognizer(tapRecognizer)
    }

    func setConstraints() {
        self.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let margins = self.layoutMarginsGuide

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dueLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false

        // Constrain the titleLabel to the right, left, and top of cell
        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true

        // Ensure height of titleLabel is 1/4 of cell height
        titleLabel.heightAnchor.constraint(equalToConstant: self.bounds.height / 4).isActive = true

        // Constrain descLabel to right and left anchors of cell
        // Constrain descLabel to bottom of titleLabel and top of dueLabel
        descLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: dueLabel.topAnchor).isActive = true

        // Constrain the dueLabel to the right, left, and bottom of cell
        dueLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        dueLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        dueLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true

        // Ensure height of dueLabel is 1/4 of cell height
        dueLabel.heightAnchor.constraint(equalToConstant: self.bounds.height / 4).isActive = true
    }

    /// Configure the AssignmentCell with a Assignment object
    ///
    /// - Parameters:
    ///   - item: The Assignment to be used as the model for the cell
    ///   - indexPath: The indexPath at which the AssignmentCell will be displayed in the UICollectionView
    func configure(_ item: Assignment, at indexPath: IndexPath) {
        titleLabel.titleLabel.text = item.title
        dueLabel.titleLabel.text = "Due: \(item.dueTimeString)"
        descLabel.attributedText = item.attributedInstructions
        tapRecognizer.indexPath = indexPath
    }
}

/// A UITapGestureRecognizer that contains an indexPath object to indicate tapped object
///
/// For use with textView within AssignmentCell
class IndexRecognizer: UITapGestureRecognizer {
    var indexPath: IndexPath!
}
