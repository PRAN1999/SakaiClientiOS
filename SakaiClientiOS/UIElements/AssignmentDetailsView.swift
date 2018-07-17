//
//  AssignmentDetailsView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/22/18.
//

import UIKit

/// A customized scrollView containing views for all the information needed for an Assignment
class AssignmentDetailsView: UIScrollView {
    
    var contentView:UIView!
    
    /// A label for the class associated with the Assignment
    var classLabel:DetailLabel!
    
    /// A label detailing the status of the Assignment
    var statusLabel:DetailLabel!
    
    /// The label containing the max points of the Assignment
    var pointsLabel:DetailLabel!
    
    /// A label containing the due date of the Assignment
    var dueLabel:DetailLabel!
    
    /// A label for the current grade of the Assignment
    var gradeLabel:DetailLabel!
    
    /// A label for the submission status of the Assignment
    var submissionLabel:DetailLabel!
    
    var instructionView:UITextView!
    var attachmentsView:UITextView!
    
    var instructionTapRecognizer:UITapGestureRecognizer!
    var attachmentsTapRecognizer:UITapGestureRecognizer!

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
        contentView = UIView()
        
        classLabel = DetailLabel()
        statusLabel = DetailLabel()
        pointsLabel = DetailLabel()
        dueLabel = DetailLabel()
        gradeLabel = DetailLabel()
        submissionLabel = DetailLabel()
        instructionView = UITextView()
        attachmentsView = UITextView()
        
        prepareTextView(instructionView)
        prepareTextView(attachmentsView)
        
        instructionTapRecognizer = UITapGestureRecognizer(target: nil, action: nil)
        instructionTapRecognizer.cancelsTouchesInView = false
        
        attachmentsTapRecognizer = UITapGestureRecognizer(target: nil, action: nil)
        attachmentsTapRecognizer.cancelsTouchesInView = false
    }
    
    func addViews() {
        self.addSubview(contentView)
        
        contentView.addSubview(classLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(pointsLabel)
        contentView.addSubview(dueLabel)
        contentView.addSubview(gradeLabel)
        contentView.addSubview(submissionLabel)
        contentView.addSubview(instructionView)
        contentView.addSubview(attachmentsView)
        
        instructionView.addGestureRecognizer(instructionTapRecognizer)
        attachmentsView.addGestureRecognizer(attachmentsTapRecognizer)
    }
    
    func setConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        classLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        dueLabel.translatesAutoresizingMaskIntoConstraints = false
        gradeLabel.translatesAutoresizingMaskIntoConstraints = false
        submissionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionView.translatesAutoresizingMaskIntoConstraints = false
        attachmentsView.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = contentView.layoutMarginsGuide
        
        classLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        classLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        classLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        classLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor).isActive = true
        
        statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        statusLabel.bottomAnchor.constraint(equalTo: pointsLabel.topAnchor).isActive = true
        
        pointsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        pointsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        pointsLabel.bottomAnchor.constraint(equalTo: dueLabel.topAnchor).isActive = true
        
        dueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        dueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        dueLabel.bottomAnchor.constraint(equalTo: gradeLabel.topAnchor).isActive = true
        
        gradeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        gradeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        gradeLabel.bottomAnchor.constraint(equalTo: submissionLabel.topAnchor).isActive = true
        
        submissionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        submissionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        submissionLabel.bottomAnchor.constraint(equalTo: instructionView.topAnchor, constant: -10.0).isActive = true
        
        instructionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0).isActive = true
        instructionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0).isActive = true
        instructionView.bottomAnchor.constraint(equalTo: attachmentsView.topAnchor, constant: -10.0).isActive = true
        
        attachmentsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0).isActive = true
        attachmentsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5.0).isActive = true
        attachmentsView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    /// Configure and format instructionText before displaying in instructionView
    ///
    /// - Parameter attributedText: The body of the instruction content for the Assignment
    func setInstructions(attributedText: NSAttributedString?) {
        guard let text = attributedText else {
            return
        }
        let instructions = NSMutableAttributedString(attributedString: text)
        let instructionRange = NSRange(location: 0, length: instructions.string.count)
        instructions.addAttribute(.font, value: UIFont.systemFont(ofSize: 16.0, weight: .regular), range: instructionRange)
        
        let description = NSMutableAttributedString(string: "Instructions: \n\n")
        let descriptionRange = NSRange(location: 0, length: description.string.count)
        description.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18.0), range: descriptionRange)
        
        description.append(instructions)
        instructionView.attributedText = description
    }
    
    /// Format Assignment attachment links and add them to the attachmentsView
    ///
    /// - Parameter resources: The resources for the Assignment to add to the attachmentsView
    func setAttachments(resources:[NSAttributedString]?) {
        guard let attachments = resources else {
            return
        }
        let description = NSMutableAttributedString(string: "Attachments: \n\n")
        let descriptionRange = NSRange(location: 0, length: description.string.count)
        description.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18.0), range: descriptionRange)
        
        for attachment in attachments {
            let mutableAttachment = NSMutableAttributedString(attributedString: attachment)
            let mutableAttachmentRange = NSRange(location: 0, length: mutableAttachment.string.count)
            mutableAttachment.addAttribute(.font, value: UIFont.systemFont(ofSize: 16.0, weight: .regular), range: mutableAttachmentRange)
            description.append(mutableAttachment)
            
            
            let spaceString = "\n\n"
            description.append(NSAttributedString(string: spaceString))
        }
        attachmentsView.attributedText = description
    }
    
    /// Remove editable functionality of textView and remove ability to scroll because it will be added to another scrollView
    ///
    /// - Parameter textView: The textView to configure
    private func prepareTextView(_ textView:UITextView) {
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set the content size of self (scrollView) to the size of the content view by using the maxY of the attachmentsView (the farthest down point of all the content)
        let maxY = attachmentsView.frame.maxY
        contentSize = CGSize(width: self.frame.width, height: maxY + 10)
    }
}
