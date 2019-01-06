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
    static let cellHeight: CGFloat = 280 * 0.7
    static let flipDuration = 0.2

    typealias T = Assignment

    let frontView = UIView.defaultAutoLayoutView()

    var isFlipped: Bool {
        return frontView.isHidden
    }

    enum FlipAction { case toFront, toBack, toggle }

    let titleLabel: IconLabel = {
        let titleLabel: IconLabel = UIView.defaultAutoLayoutView()
        titleLabel.backgroundColor = Palette.main.primaryBackgroundColor
        titleLabel.textColor = Palette.main.primaryTextColor
        titleLabel.font = UIFont.boldSystemFont(ofSize: 11.0)
        titleLabel.addBorder(toSide: .bottom,
                             withColor: Palette.main.highlightColor,
                             andThickness: 2.5)
        titleLabel.iconLabel.font = UIFont(name: AppIcons.siteFont, size: 15.0)
        titleLabel.iconVisibleConstraint.constant = 15
        titleLabel.iconLabel.textColor = Palette.main.tertiaryBackgroundColor
        titleLabel.numberOfLines = 2
        return titleLabel
    }()

    let dueLabel: IconLabel = {
        let dueLabel: IconLabel = UIView.defaultAutoLayoutView()
        dueLabel.backgroundColor = Palette.main.primaryBackgroundColor
        dueLabel.textColor = Palette.main.secondaryTextColor
        dueLabel.font = UIFont.boldSystemFont(ofSize: 10.7)
        dueLabel.addBorder(toSide: .top, withColor: Palette.main.highlightColor, andThickness: 2.5)
        dueLabel.iconVisibleConstraint.constant = 15
        dueLabel.iconLabel.font = UIFont(name: AppIcons.generalIconFont, size: 15)
        dueLabel.iconLabel.textColor = Palette.main.tertiaryBackgroundColor
        dueLabel.iconText = AppIcons.dueIcon
        dueLabel.titleLabel.adjustsFontSizeToFitWidth = true
        dueLabel.numberOfLines = 1
        return dueLabel
    }()

    let descLabel: UITextView = {
        let descLabel: UITextView = UIView.defaultAutoLayoutView()
        descLabel.isEditable = false
        descLabel.isSelectable = true
        descLabel.backgroundColor = Palette.main.tertiaryBackgroundColor
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
        contentView.layer.borderWidth = 0.4
        contentView.layer.borderColor = Palette.main.borderColor.cgColor
        contentView.layer.cornerRadius = AssignmentCell.cornerRadius
        contentView.layer.masksToBounds = true

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

        contentView.addSubview(frontView)
    }

    private func setConstraints() {
        frontView.constrainToEdges(of: contentView)

        frontView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        titleLabel.constrainToMargins(of: frontView, onSides: [.right, .left, .top])
        titleLabel.heightAnchor.constraint(equalTo: frontView.heightAnchor,
                                           multiplier: 0.25).isActive = true

        descLabel.constrainToMargins(of: frontView, onSides: [.left, .right])
        descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: dueLabel.topAnchor).isActive = true

        dueLabel.constrainToMargins(of: frontView, onSides: [.left, .right, .bottom])
        dueLabel.heightAnchor.constraint(equalTo: frontView.heightAnchor,
                                         multiplier: 0.25).isActive = true
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
                contentView.addSubview(pageView)
                pageView.constrainToEdges(of: contentView)
            } else {
                pageView.removeFromSuperview()
            }
            completion()
            return
        }
        contentView.addSubview(pageView)
        pageView.constrainToEdges(of: contentView)
        if frontViewHidden {
            UIView.transition(from: frontView,
                              to: pageView,
                              duration: AssignmentCell.flipDuration,
                              options: [.transitionFlipFromTop,
                                        .showHideTransitionViews]) { _ in
                completion()
            }
        } else {
            UIView.transition(from: pageView,
                              to: frontView,
                              duration: AssignmentCell.flipDuration,
                              options: [.transitionFlipFromBottom,
                                        .showHideTransitionViews]) { [weak self] _ in
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
        if let code = item.subjectCode, let icon = AppIcons.codeToIcon[code] {
            titleLabel.iconText = icon
        } else {
            titleLabel.iconText = nil
        }
        titleLabel.text = item.title
        dueLabel.text = "\(item.dueTimeString)"
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
