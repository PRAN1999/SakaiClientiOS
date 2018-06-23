//
//  SiteCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/27/18.
//

import UIKit

class SiteCell: UITableViewCell {
    
    static let reuseIdentifier: String = "siteTableViewCell"

    var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

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
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
    }
    
    func addViews() {
        self.contentView.addSubview(titleLabel)
        self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    }
    
    func setConstraints() {
        let margins = self.contentView.layoutMarginsGuide
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 20.0).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        self.titleLabel.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1.0).isActive = true
    }
    
    func setTitle(title: String) {
        self.titleLabel.text = title
    }
}
