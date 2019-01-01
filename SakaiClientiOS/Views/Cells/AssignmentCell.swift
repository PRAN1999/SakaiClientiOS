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

    var isFlipped: Bool {
        return frontView.isHidden
    }

    enum FlipAction { case toFront, toBack, toggle }

    let titleLabel: InsetUILabel = {
        let titleLabel: InsetUILabel = UIView.defaultAutoLayoutView()
        titleLabel.backgroundColor = UIColor.darkGray
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 11.0)
        titleLabel.addBorder(toSide: .bottom, withColor: AppGlobals.sakaiRed, andThickness: 2.5)
        return titleLabel
    }()

    let dueLabel: InsetUILabel = {
        let dueLabel: InsetUILabel = UIView.defaultAutoLayoutView()
        dueLabel.backgroundColor = UIColor.darkGray
        dueLabel.textColor = UIColor.lightText
        dueLabel.font = UIFont.boldSystemFont(ofSize: 10.7)
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

    override func prepareForReuse() {
        super.prepareForReuse()
        frontView.isHidden = false
        pageView.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.lightText.cgColor
        contentView.layer.cornerRadius = AssignmentCell.cornerRadius
        contentView.layer.masksToBounds = true

        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.shadowColor = UIColor.black.cgColor
        let shadowPath = UIBezierPath(roundedRect: bounds,
                                      byRoundingCorners: [.bottomRight, .bottomLeft, .topRight],
                                      cornerRadii: CGSize(width: AssignmentCell.cornerRadius,
                                                          height: AssignmentCell.cornerRadius))
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 0.5

        selectedBackgroundView = darkSelectedView()
        selectedBackgroundView?.layer.cornerRadius = 10

        frontView.addSubview(titleLabel)
        frontView.addSubview(dueLabel)
        frontView.addSubview(descLabel)
        descLabel.addGestureRecognizer(tapRecognizer)

        pageView.isHidden = true
        pageView.isScrollEnabled = false
        pageViewTap.cancelsTouchesInView = false
        pageView.addGestureRecognizer(pageViewTap)
    }

    private func setConstraints() {

        UIView.constrainChildToEdges(child: frontView, parent: contentView)

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

    func flip(withDirection action: FlipAction = .toggle, animated: Bool = true, completion: @escaping () -> Void) {
        switch action {
        case .toFront:
            setState(frontViewHidden: false, animated: animated, completion: completion)
        case .toBack:
            setState(frontViewHidden: true, animated: animated, completion: completion)
        case .toggle:
            setState(frontViewHidden: !frontView.isHidden, animated: animated, completion: completion)
        }
    }

    private func setState(frontViewHidden: Bool, animated: Bool, completion: @escaping () -> Void) {
        if !animated {
            frontView.isHidden = frontViewHidden
            pageView.isHidden = !frontViewHidden
            if frontViewHidden {
                UIView.constrainChildToEdges(child: pageView, parent: contentView)
            } else {
                pageView.removeFromSuperview()
            }
            completion()
            return
        }
        UIView.constrainChildToEdges(child: pageView, parent: contentView)
        if frontViewHidden {
            UIView.transition(from: frontView,
                              to: pageView,
                              duration: AssignmentCell.flipDuration,
                              options: [.transitionFlipFromTop, .showHideTransitionViews]) { _ in
                completion()
            }
        } else {
            UIView.transition(from: pageView,
                              to: frontView,
                              duration: AssignmentCell.flipDuration,
                              options: [.transitionFlipFromBottom, .showHideTransitionViews]) { [weak self] _ in
                self?.pageView.removeFromSuperview()
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
