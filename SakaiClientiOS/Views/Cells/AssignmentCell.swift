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
    
    typealias T = Assignment

    var titleLabel: InsetUILabel!
    var dueLabel: InsetUILabel!
    var descLabel: UITextView!
    
    var shouldSetConstraints = true

    /// Since the textView has its own recognizers, a tap on the textView will not register as a cell selection
    ///
    /// The tapRecognizer forwards the taps to the UICollectionViewDelegate
    var tapRecognizer: IndexRecognizer!

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
        titleLabel = InsetUILabel()
        dueLabel = InsetUILabel()
        descLabel = UITextView()

        titleLabel.backgroundColor = AppGlobals.sakaiRed
        dueLabel.backgroundColor = AppGlobals.sakaiRed//UIColor.black
        titleLabel.titleLabel.textColor = UIColor.white
        dueLabel.titleLabel.textColor = UIColor.white

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

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dueLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        setNeedsUpdateConstraints()
    }

    func addViews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(dueLabel)
        self.contentView.addSubview(descLabel)
        descLabel.addGestureRecognizer(tapRecognizer)
    }

    func setConstraints() {
        self.contentView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let margins = self.contentView.layoutMarginsGuide

        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: self.contentView.bounds.height / 4).isActive = true

        descLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: dueLabel.topAnchor).isActive = true

        dueLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        dueLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        dueLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        dueLabel.heightAnchor.constraint(equalToConstant: self.contentView.bounds.height / 4).isActive = true
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
