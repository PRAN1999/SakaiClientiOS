//
//  AssignmentPageView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/22/18.
//

import UIKit

/// A customized scrollView containing views for all the information needed for an Assignment
class AssignmentPageView: UIScrollView {

    let contentView: UIView = UIView.defaultAutoLayoutView()

    let titleLabel: IconLabel = {
        let titleLabel: IconLabel = UIView.defaultAutoLayoutView()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabel.textColor = Palette.main.secondaryTextColor
        titleLabel.backgroundColor = Palette.main.secondaryBackgroundColor.color(withTransparency: 0.5)
        titleLabel.addBorder(toSide: .bottom, withColor: Palette.main.highlightColor, andThickness: 2.0)
        titleLabel.layer.cornerRadius = 0
        titleLabel.layer.masksToBounds = false
        return titleLabel
    }()

    let classLabel: DetailLabel = {
        let detailLabel: DetailLabel = UIView.defaultAutoLayoutView()
        detailLabel.iconLabel.font = UIFont(name: AppIcons.siteFont, size: 20.0)
        detailLabel.iconText = nil
        return detailLabel
    }()

    let statusLabel: DetailLabel = {
        let detailLabel: DetailLabel = UIView.defaultAutoLayoutView()
        detailLabel.iconText = AppIcons.statusOpenIcon
        return detailLabel
    }()

    let pointsLabel: DetailLabel = {
        let detailLabel: DetailLabel = UIView.defaultAutoLayoutView()
        detailLabel.iconText = AppIcons.maxGradeIcon
        return detailLabel
    }()

    let dueLabel: DetailLabel = {
        let detailLabel: DetailLabel = UIView.defaultAutoLayoutView()
        detailLabel.iconText = AppIcons.dueIcon
        return detailLabel
    }()

    let submissionLabel: DetailLabel = {
        let detailLabel: DetailLabel = UIView.defaultAutoLayoutView()
        detailLabel.iconText = AppIcons.resubmitIcon
        return detailLabel
    }()

    let instructionView: TappableTextView = {
        let instructionView: TappableTextView = UIView.defaultAutoLayoutView()
        instructionView.isScrollEnabled = false
        instructionView.backgroundColor = Palette.main.secondaryBackgroundColor.color(withTransparency: 0.3)
        instructionView.contentInset = UIEdgeInsets(top: 2.0, left: 5.0, bottom: 0.0, right: 5.0)
        instructionView.tintColor = Palette.main.linkColor
        instructionView.addBorder(toSide: .top, withColor: Palette.main.highlightColor, andThickness: 1.0)
        return instructionView
    }()

    let spaceView: UIView = {
        let spaceView = UIView.defaultAutoLayoutView()
        spaceView.backgroundColor = Palette.main.primaryBackgroundColor
        return spaceView
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
        backgroundColor = Palette.main.primaryBackgroundColor
        contentView.backgroundColor = Palette.main.primaryBackgroundColor

        addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(classLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(pointsLabel)
        contentView.addSubview(dueLabel)
        contentView.addSubview(submissionLabel)
        contentView.addSubview(instructionView)
        contentView.addSubview(spaceView)
    }

    private func setConstraints() {
        contentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        titleLabel.constrainToEdges(of: contentView, onSides: [.left, .top, .right])
        titleLabel.bottomAnchor.constraint(equalTo: classLabel.topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor,
                                           multiplier: 0.12).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0).isActive = true

        classLabel.constrainToEdges(of: contentView, onSides: [.left, .right])
        classLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor).isActive = true

        statusLabel.constrainToEdges(of: contentView, onSides: [.left, .right])
        statusLabel.bottomAnchor.constraint(equalTo: pointsLabel.topAnchor).isActive = true

        pointsLabel.constrainToEdges(of: contentView, onSides: [.left, .right])
        pointsLabel.bottomAnchor.constraint(equalTo: dueLabel.topAnchor).isActive = true

        dueLabel.constrainToEdges(of: contentView, onSides: [.left, .right])
        dueLabel.bottomAnchor.constraint(equalTo: submissionLabel.topAnchor).isActive = true

        submissionLabel.constrainToEdges(of: contentView, onSides: [.left, .right])
        submissionLabel.bottomAnchor.constraint(equalTo: instructionView.topAnchor,
                                                constant: -10.0).isActive = true

        instructionView.constrainToEdges(of: contentView, onSides: [.left, .right])
        instructionView.bottomAnchor.constraint(equalTo: spaceView.topAnchor).isActive = true

        spaceView.constrainToEdges(of: contentView, onSides: [.left, .right])
        spaceView.constrainToMargin(of: contentView, onSide: .bottom)
        spaceView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Set the content size of self (scrollView) to the size of the
        // content view by using the maxY of the attachmentsView (the
        // farthest down point of all the content)
        let maxY = spaceView.frame.maxY
        contentSize = CGSize(width: frame.width, height: maxY)
    }
}

extension AssignmentPageView {

    func configure(assignment: Assignment) {
        titleLabel.titleLabel.text = assignment.title

        classLabel.setKeyVal(key: "Class:", val: assignment.siteTitle)
        pointsLabel.setKeyVal(key: "Max Points:", val: assignment.maxPoints)
        if let resubmission = assignment.resubmissionAllowed {
            submissionLabel.setKeyVal(key: "Allows Resubmission:", val: resubmission ? "Yes" : "No")
        }
        statusLabel.setKeyVal(key: "Status:", val: assignment.status.descriptor)
        if assignment.status == .closed {
            statusLabel.iconText = AppIcons.closedStatusIcon
        } else {
            statusLabel.iconText = AppIcons.statusOpenIcon
        }
        dueLabel.setKeyVal(key: "Due:", val: assignment.dueTimeString)
        guard let instructions = PageView.getInstructionsString(attributedText: assignment.attributedInstructions)
            else {
            return
        }
        let resourceStrings = assignment.attachments?.map({ (attachment) -> NSAttributedString in
            return attachment.toAttributedString()
        })
        if let attachments = PageView.getAttachmentsString(resources: resourceStrings) {
            instructions.append(attachments)
        }
        instructionView.attributedText = instructions

        if let code = assignment.subjectCode {
            classLabel.iconText = AppIcons.codeToIcon[code]
        }
    }
}
