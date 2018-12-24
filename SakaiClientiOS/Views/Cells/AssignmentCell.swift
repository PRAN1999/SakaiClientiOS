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

    static let cornerRadius: CGFloat = 10.0
    static let flipDuration = 0.2

    typealias T = Assignment

    let frontView = UIView.defaultAutoLayoutView()

    let titleLabel: InsetUILabel = {
        let titleLabel: InsetUILabel = UIView.defaultAutoLayoutView()
        titleLabel.backgroundColor = UIColor.darkGray
        titleLabel.titleLabel.textColor = UIColor.white
        titleLabel.titleLabel.font = UIFont.boldSystemFont(ofSize: 11.0)
        titleLabel.addBorder(toSide: .bottom, withColor: AppGlobals.sakaiRed, andThickness: 2.5)
        return titleLabel
    }()

    let dueLabel: InsetUILabel = {
        let dueLabel: InsetUILabel = UIView.defaultAutoLayoutView()
        dueLabel.backgroundColor = UIColor.darkGray
        dueLabel.titleLabel.textColor = UIColor.lightText
        dueLabel.titleLabel.font = UIFont.boldSystemFont(ofSize: 10.7)
        dueLabel.addBorder(toSide: .top, withColor: AppGlobals.sakaiRed, andThickness: 2.5)
        return dueLabel
    }()

    let descLabel: UITextView = {
        let descLabel: UITextView = UIView.defaultAutoLayoutView()
        descLabel.isEditable = false
        descLabel.isSelectable = true
        descLabel.backgroundColor = UIColor.lightGray
        descLabel.textContainerInset = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
        return descLabel
    }()

    let pageView: AssignmentPageView = UIView.defaultAutoLayoutView()
    let pageViewTap = IndexRecognizer(target: nil, action: nil)

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
        contentView.layer.borderWidth = 3.5
        contentView.layer.borderColor = UIColor.lightText.cgColor
        contentView.layer.cornerRadius = AssignmentCell.cornerRadius
        contentView.layer.masksToBounds = true

        selectedBackgroundView = darkSelectedView()
        selectedBackgroundView?.layer.cornerRadius = 10

        frontView.addSubview(titleLabel)
        frontView.addSubview(dueLabel)
        frontView.addSubview(descLabel)
        descLabel.addGestureRecognizer(tapRecognizer)

        pageView.isHidden = true
        pageView.isScrollEnabled = false
        pageView.backgroundColor = UIColor.white
        pageViewTap.cancelsTouchesInView = false
        pageView.addGestureRecognizer(pageViewTap)
    }

    private func setConstraints() {

        UIView.constrainChildToEdges(child: frontView, parent: contentView)
        UIView.constrainChildToEdges(child: pageView, parent: contentView)

        frontView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let margins = frontView.layoutMarginsGuide

        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: frontView.heightAnchor, multiplier: 0.25).isActive = true

        descLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: dueLabel.topAnchor).isActive = true

        dueLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        dueLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        dueLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        dueLabel.heightAnchor.constraint(equalTo: frontView.heightAnchor, multiplier: 0.25).isActive = true
    }

    func flip(completion: @escaping () -> Void) {
        if frontView.isHidden {
            UIView.transition(from: pageView, to: frontView, duration: AssignmentCell.flipDuration, options: [.transitionFlipFromTop, .showHideTransitionViews]) { flag in
                completion()
            }
        } else {
            UIView.transition(from: frontView, to: pageView, duration: AssignmentCell.flipDuration, options: [.transitionFlipFromBottom, .showHideTransitionViews]) { flag in
                completion()
            }
        }
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
        pageViewTap.indexPath = indexPath

        pageView.configure(assignment: item)
    }
}

/// A UITapGestureRecognizer that contains an indexPath object to indicate tapped object
///
/// For use with textView within AssignmentCell
class IndexRecognizer: UITapGestureRecognizer {
    var indexPath: IndexPath?
}
