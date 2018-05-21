//
//  GradebookCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/13/18.
//

import UIKit

class GradebookCell: UITableViewCell {
    
    var titleLabel:UILabel!
    var gradeLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
        self.addViews()
        self.setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        self.titleLabel = UILabel()
        self.gradeLabel = UILabel()
        self.gradeLabel.textAlignment = NSTextAlignment.right
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    }
    
    func addViews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(gradeLabel)
    }
    
    func setConstraints() {
        let margins = self.contentView.layoutMarginsGuide
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.gradeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        
        self.gradeLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.gradeLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.gradeLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        self.contentView.addConstraint(NSLayoutConstraint(
            item: titleLabel,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: gradeLabel,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0.0)
        )
        
        self.contentView.addConstraint(NSLayoutConstraint(
            item: titleLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: margins,
            attribute: .width,
            multiplier: 0.5,
            constant: 0)
        )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
