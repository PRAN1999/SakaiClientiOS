//
//  AssignmentCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/10/18.
//

import UIKit

class AssignmentCell: UICollectionViewCell {
    
    static let reuseIdentifier:String = "assignmentCell"
    
    var titleLabel:InsetTextBackgroundView!
    var dueLabel:InsetTextBackgroundView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.addViews()
        self.setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.titleLabel = InsetTextBackgroundView()
        self.dueLabel = InsetTextBackgroundView()
        
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func addViews() {
        self.addSubview(titleLabel)
        self.addSubview(dueLabel)
    }
    
    func setConstraints() {
        self.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let margins = self.layoutMarginsGuide
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: self.bounds.height / 5).isActive = true
        
        self.dueLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.dueLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.dueLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        self.dueLabel.heightAnchor.constraint(equalToConstant: self.bounds.height / 5).isActive = true
        
        let constraint = NSLayoutConstraint(item: self.dueLabel,
                                            attribute: .top,
                                            relatedBy: .greaterThanOrEqual,
                                            toItem: self.titleLabel,
                                            attribute: .bottom,
                                            multiplier: 1.0,
                                            constant: 120.0)
        self.addConstraint(constraint)
    }
    
}
