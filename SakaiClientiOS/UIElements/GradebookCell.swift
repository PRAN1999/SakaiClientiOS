//
//  GradebookCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/13/18.
//

import UIKit

class GradebookCell: UITableViewCell {
    
    static let reuseIdentifier: String = "gradebookCell"
    
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
        self.gradeLabel = UILabel()
        self.gradeLabel.textAlignment = NSTextAlignment.right
        
        self.titleLabel = UILabel()
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
        self.titleLabel.trailingAnchor.constraint(equalTo: self.gradeLabel.leadingAnchor).isActive = true
        self.titleLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5).isActive = true
        
        self.gradeLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.gradeLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.gradeLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
