//
//  AssignmentCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/10/18.
//

import UIKit
import WebKit

class AssignmentCell: UICollectionViewCell {
    
    static let reuseIdentifier:String = "assignmentCell"
    
    var titleLabel:InsetUILabel!
    var dueLabel:InsetUILabel!
    var descLabel:UITextView!
    
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
        self.titleLabel = InsetUILabel()
        self.dueLabel = InsetUILabel()
        self.descLabel = UITextView()
        
        self.descLabel.isEditable = false
        self.descLabel.isSelectable = true
        self.descLabel.backgroundColor = UIColor.white
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
    }
    
    func addViews() {
        self.addSubview(titleLabel)
        self.addSubview(dueLabel)
        self.addSubview(descLabel)
    }
    
    func setConstraints() {
        self.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let margins = self.layoutMarginsGuide
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: self.bounds.height / 4).isActive = true
        
        self.dueLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.dueLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.dueLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        self.dueLabel.heightAnchor.constraint(equalToConstant: self.bounds.height / 4).isActive = true
        
        self.descLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.descLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        self.descLabel.bottomAnchor.constraint(equalTo: dueLabel.topAnchor).isActive = true
    }
}
