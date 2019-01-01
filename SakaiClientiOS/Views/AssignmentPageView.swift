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

    let titleLabel: InsetUILabel = {
        let titleLabel: InsetUILabel = UIView.defaultAutoLayoutView()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        titleLabel.layer.shadowOpacity = 0.5
        titleLabel.layer.shadowRadius = 2.5
        titleLabel.layer.masksToBounds = false
        titleLabel.backgroundColor = UIColor.lightGray.color(withTransparency: 0.5)
        titleLabel.addBorder(toSide: .bottom, withColor: AppGlobals.sakaiRed, andThickness: 2.0)
        return titleLabel
    }()

    let classLabel: DetailLabel = UIView.defaultAutoLayoutView()

    let statusLabel: DetailLabel = UIView.defaultAutoLayoutView()

    let pointsLabel: DetailLabel = UIView.defaultAutoLayoutView()

    let dueLabel: DetailLabel = UIView.defaultAutoLayoutView()

    let submissionLabel: DetailLabel = UIView.defaultAutoLayoutView()

    let instructionView: TappableTextView = {
        let instructionView: TappableTextView = UIView.defaultAutoLayoutView()
        instructionView.isScrollEnabled = false
        instructionView.backgroundColor = UIColor.lightGray.color(withTransparency: 0.5)
        instructionView.layer.shadowColor = UIColor.black.cgColor
        instructionView.layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
        instructionView.layer.shadowOpacity = 0.5
        instructionView.layer.shadowRadius = 2.5
        instructionView.layer.masksToBounds = false
        instructionView.contentInset = UIEdgeInsets(top: 2.0, left: 5.0, bottom: 0.0, right: 5.0)
        instructionView.tintColor = UIColor(red: 70.0 / 256.0, green: 188.0 / 256.0, blue: 222.0 / 256.0, alpha: 1.0)
        instructionView.addBorder(toSide: .top, withColor: AppGlobals.sakaiRed, andThickness: 1.0)
        return instructionView
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
        backgroundColor = UIColor.darkGray
        contentView.backgroundColor = UIColor.darkGray

        addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(classLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(pointsLabel)
        contentView.addSubview(dueLabel)
        contentView.addSubview(submissionLabel)
        contentView.addSubview(instructionView)
    }

    private func setConstraints() {
        contentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        let margins = contentView.layoutMarginsGuide

        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: classLabel.topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor,
                                           multiplier: 0.12).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0).isActive = true

        classLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        classLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        classLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor).isActive = true

        statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        statusLabel.bottomAnchor.constraint(equalTo: pointsLabel.topAnchor).isActive = true

        pointsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        pointsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        pointsLabel.bottomAnchor.constraint(equalTo: dueLabel.topAnchor).isActive = true

        dueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        dueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        dueLabel.bottomAnchor.constraint(equalTo: submissionLabel.topAnchor).isActive = true

        submissionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        submissionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        submissionLabel.bottomAnchor.constraint(equalTo: instructionView.topAnchor,
                                                constant: -10.0).isActive = true

        instructionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        instructionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        instructionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Set the content size of self (scrollView) to the size of the
        // content view by using the maxY of the attachmentsView (the
        // farthest down point of all the content)
        let maxY = instructionView.frame.maxY
        contentSize = CGSize(width: self.frame.width, height: maxY)
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
        statusLabel.setKeyVal(key: "Status:", val: assignment.status)
        dueLabel.setKeyVal(key: "Due:", val: assignment.dueTimeString)
        guard let instructions = getInstructionsString(attributedText: assignment.attributedInstructions) else {
            return
        }
        let resourceStrings = assignment.attachments?.map({ (attachment) -> NSAttributedString in
            return attachment.toAttributedString()
        })
        if let attachments = getAttachmentsString(resources: resourceStrings) {
            instructions.append(attachments)
        }
        instructionView.attributedText = instructions
    }

    private func getInstructionsString(attributedText: NSAttributedString?) -> NSMutableAttributedString? {
        guard let text = attributedText else {
            return nil
        }
        let instructions = NSMutableAttributedString(attributedString: text)
        let instructionRange = NSRange(location: 0, length: instructions.string.count)
        instructions.addAttribute(.font,
                                  value: UIFont.systemFont(ofSize: 16.0, weight: .regular),
                                  range: instructionRange)
        instructions.addAttribute(.foregroundColor, value: UIColor.lightText, range: instructionRange)

        let description = NSMutableAttributedString(string: "Instructions: \n\n")
        let descriptionRange = NSRange(location: 0, length: description.string.count)
        description.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18.0), range: descriptionRange)
        description.addAttribute(.foregroundColor, value: UIColor.white, range: descriptionRange)
        description.append(instructions)
        return description
    }

    private func getAttachmentsString(resources: [NSAttributedString]?) -> NSMutableAttributedString? {
        guard let attachments = resources else {
            print("here?")
            return nil
        }
        let description = NSMutableAttributedString(string: "\n\n\nAttachments: \n\n")
        let descriptionRange = NSRange(location: 0, length: description.string.count)
        description.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18.0), range: descriptionRange)
        description.addAttribute(.foregroundColor, value: UIColor.white, range: descriptionRange)

        for attachment in attachments {
            let mutableAttachment = NSMutableAttributedString(attributedString: attachment)
            let mutableAttachmentRange = NSRange(location: 0, length: mutableAttachment.string.count)
            mutableAttachment.addAttribute(.font,
                                           value: UIFont.systemFont(ofSize: 16.0, weight: .regular),
                                           range: mutableAttachmentRange)
            description.append(mutableAttachment)
            let spaceString = "\n\n"
            description.append(NSAttributedString(string: spaceString))
        }
        return description
    }
}

