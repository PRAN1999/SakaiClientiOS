//
//  GradebookCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/13/18.
//

import UIKit

class GradebookCell: UITableViewCell {
    
    var titleLabel:UILabel!
    var dateLabel:UILabel!
    var gradeLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup() {
        self.titleLabel = UILabel(frame: self.contentView.bounds)
        self.dateLabel = UILabel(frame: self.contentView.bounds)
        self.gradeLabel = UILabel(frame: self.contentView.bounds)
    }
    
    func addSubviews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(gradeLabel)
    }
    
    func setConstraints() {
        let margins = self.contentView.layoutMarginsGuide
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.gradeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        self.titleLabel.topAnchor.constraint(equalTo: margins.topAnchor)
        self.dateLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        self.dateLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        
        self.contentView.addConstraint(NSLayoutConstraint(
            item: titleLabel,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: dateLabel,
            attribute: .top,
            multiplier: 1.0,
            constant: 5.0)
        )
        
        self.gradeLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        self.gradeLabel.topAnchor.constraint(equalTo: margins.topAnchor)
        self.gradeLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        
        self.contentView.addConstraint(NSLayoutConstraint(
            item: titleLabel,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: gradeLabel,
            attribute: .leading,
            multiplier: 1.0,
            constant: 5.0)
        )
        
        self.contentView.addConstraint(NSLayoutConstraint(
            item: dateLabel,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: gradeLabel,
            attribute: .leading,
            multiplier: 1.0,
            constant: 5.0)
        )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(item: GradeItem) {
        self.titleLabel.text = item.getTitle()
        self.gradeLabel.text = String(item.getGrade())
    }

}
