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
        titleLabel.backgroundColor = AppGlobals.sakaiRed
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabel.layer.cornerRadius = 0
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
        return instructionView
    }()

    let attachmentsView: TappableTextView = {
        let attachmentsView: TappableTextView = UIView.defaultAutoLayoutView()
        attachmentsView.isScrollEnabled = false
        return attachmentsView
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
        addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(classLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(pointsLabel)
        contentView.addSubview(dueLabel)
        contentView.addSubview(submissionLabel)
        contentView.addSubview(instructionView)
        contentView.addSubview(attachmentsView)
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

        instructionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                 constant: 5.0).isActive = true
        instructionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                  constant: -5.0).isActive = true
        instructionView.bottomAnchor.constraint(equalTo: attachmentsView.topAnchor,
                                                constant: -10.0).isActive = true

        attachmentsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                 constant: 5.0).isActive = true
        attachmentsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                  constant: -5.0).isActive = true
        attachmentsView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Set the content size of self (scrollView) to the size of the
        // content view by using the maxY of the attachmentsView (the
        // farthest down point of all the content)
        let maxY = attachmentsView.frame.maxY
        contentSize = CGSize(width: self.frame.width, height: maxY + 30)
    }
}

extension AssignmentPageView {

    func configure(assignment: Assignment) {
        titleLabel.titleLabel.text = assignment.title

        classLabel.setKeyVal(key: "Class:", val: assignment.siteTitle)
        pointsLabel.setKeyVal(key: "Max Points:", val: assignment.maxPoints)
        submissionLabel.setKeyVal(key: "Allows Resubmission:", val: assignment.resubmissionAllowed)
        statusLabel.setKeyVal(key: "Status:", val: assignment.status)
        dueLabel.setKeyVal(key: "Due:", val: assignment.dueTimeString)
        setInstructions(attributedText: assignment.attributedInstructions)
        let resourceStrings = assignment.attachments?.map({ (attachment) -> NSAttributedString in
            return attachment.toAttributedString()
        })
        setAttachments(resources: resourceStrings)
    }

    /// Configure and format instructionText before displaying in instructionView
    ///
    /// - Parameter attributedText: The body of the instruction content for the Assignment
    private func setInstructions(attributedText: NSAttributedString?) {
        guard let text = attributedText else {
            return
        }
        let instructions = NSMutableAttributedString(attributedString: text)
        let instructionRange = NSRange(location: 0, length: instructions.string.count)
        instructions.addAttribute(.font,
                                  value: UIFont.systemFont(ofSize: 16.0, weight: .regular), range: instructionRange)
        let description = NSMutableAttributedString(string: "Instructions: \n\n")
        let descriptionRange = NSRange(location: 0, length: description.string.count)
        description.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18.0), range: descriptionRange)
        description.append(instructions)
        instructionView.attributedText = description
    }

    /// Format Assignment attachment links and add them to the attachmentsView
    ///
    /// - Parameter resources: The resources for the Assignment to add to the attachmentsView
    private func setAttachments(resources: [NSAttributedString]?) {
        guard let attachments = resources else {
            return
        }
        let description = NSMutableAttributedString(string: "Attachments: \n\n")
        let descriptionRange = NSRange(location: 0, length: description.string.count)
        description.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18.0), range: descriptionRange)

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
        attachmentsView.attributedText = description
    }
}

