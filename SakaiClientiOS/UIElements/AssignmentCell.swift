//
//  AssignmentCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/10/18.
//

import UIKit

class AssignmentCell: UICollectionViewCell {
    
    static let reuseIdentifier:String = "assignmentCell"
    
    var titleLabel:UILabel!
    var dueLabel:UILabel!
    
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
        self.titleLabel = UILabel()
        self.dueLabel = UILabel()
        
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.titleLabel.font = UIFont.systemFont(ofSize: 10.0, weight: UIFont.Weight.light)
        
        self.dueLabel.numberOfLines = 0
        self.dueLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.dueLabel.font = UIFont.systemFont(ofSize: 10.0, weight: UIFont.Weight.light)
    }
    
    func addViews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(dueLabel)
    }
    
    func setConstraints() {
        let margins = self.contentView.layoutMarginsGuide
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        
        self.dueLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.dueLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.dueLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        let constraint = NSLayoutConstraint(item: self.titleLabel,
                                            attribute: .bottom,
                                            relatedBy: .lessThanOrEqual,
                                            toItem: self.dueLabel,
                                            attribute: .top,
                                            multiplier: 1.0,
                                            constant: -30.0)
        self.addConstraint(constraint)
    }
    
}
