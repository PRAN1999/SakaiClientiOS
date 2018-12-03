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

    let titleLabel: InsetUILabel = {
        let titleLabel: InsetUILabel = UIView.defaultAutoLayoutView()
        titleLabel.backgroundColor = AppGlobals.sakaiRed
        titleLabel.titleLabel.textColor = UIColor.white
        titleLabel.titleLabel.font = UIFont.boldSystemFont(ofSize: 11.0)
        return titleLabel
    }()

    let dueLabel: InsetUILabel = {
        let dueLabel: InsetUILabel = UIView.defaultAutoLayoutView()
        dueLabel.backgroundColor = AppGlobals.sakaiRed//UIColor.black
        dueLabel.titleLabel.textColor = UIColor.white
        dueLabel.titleLabel.font = UIFont.boldSystemFont(ofSize: 10.7)
        return dueLabel
    }()

    let descLabel: UITextView = {
        let descLabel: UITextView = UIView.defaultAutoLayoutView()
        descLabel.isEditable = false
        descLabel.isSelectable = true
        descLabel.backgroundColor = UIColor.white
        return descLabel
    }()

    /// Since the textView has its own recognizers, a tap on the textView will
    /// not register as a cell selection
    ///
    /// The tapRecognizer forwards the taps to the UICollectionViewDelegate
    let tapRecognizer: IndexRecognizer = {
        let tapRecognizer = IndexRecognizer(target: nil, action: nil)
        tapRecognizer.cancelsTouchesInView = false
        return tapRecognizer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 3
        contentView.layer.masksToBounds = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(dueLabel)
        contentView.addSubview(descLabel)
        descLabel.addGestureRecognizer(tapRecognizer)
    }

    private func setConstraints() {
        contentView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let margins = contentView.layoutMarginsGuide

        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: contentView.bounds.height / 4).isActive = true

        descLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: dueLabel.topAnchor).isActive = true

        dueLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        dueLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        dueLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        dueLabel.heightAnchor.constraint(equalToConstant: contentView.bounds.height / 4).isActive = true
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
    var indexPath: IndexPath?
}
