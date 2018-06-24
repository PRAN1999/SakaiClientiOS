//
//  AssignmentDetailsView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/22/18.
//

import UIKit

class AssignmentDetailsView: UIScrollView {
    
    var contentView:UIView!
    
    var statusLabel:DetailLabel!
    var pointsLabel:DetailLabel!
    var dueLabel:DetailLabel!
    var gradeLabel:DetailLabel!
    var submissionLabel:DetailLabel!
    
    var instructionView:UITextView!
    
    var bottomView: UIView!

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
        
        statusLabel = DetailLabel()
        pointsLabel = DetailLabel()
        dueLabel = DetailLabel()
        gradeLabel = DetailLabel()
        submissionLabel = DetailLabel()
        instructionView = UITextView()
        
        bottomView = UIView()
    }
    
    func addViews() {
        self.addSubview(contentView)
        
        self.contentView.addSubview(self.statusLabel)
        self.contentView.addSubview(self.pointsLabel)
        self.contentView.addSubview(self.dueLabel)
        self.contentView.addSubview(self.gradeLabel)
        self.contentView.addSubview(self.submissionLabel)
        self.contentView.addSubview(self.bottomView)
        self.contentView.addSubview(self.instructionView)
    }
    
    func setConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        dueLabel.translatesAutoresizingMaskIntoConstraints = false
        gradeLabel.translatesAutoresizingMaskIntoConstraints = false
        submissionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = contentView.layoutMarginsGuide
        
        statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        statusLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
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
        submissionLabel.bottomAnchor.constraint(equalTo: instructionView.topAnchor).isActive = true
        
        instructionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        instructionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        instructionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        
        bottomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
