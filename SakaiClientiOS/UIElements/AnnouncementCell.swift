//
//  AnnouncmentCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/30/18.
//

import UIKit

class AnnouncementCell: UITableViewCell {
    
    static let reuseIdentifier:String = "announcementCell"
    
    var authorLabel: UILabel!
    var titleLabel: UILabel!
    var contentLabel:UILabel!
    var dateLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    ///Setup subviews, add them to superview, and set constraints
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        addViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    ///Setup subviews
    func setup() {
        
        authorLabel = UILabel()
        authorLabel.textColor = UIColor.black
        authorLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.bold)
        
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.medium)
        
        contentLabel = UILabel()
        
        dateLabel = UILabel()
        dateLabel.textColor = UIColor.darkGray
        dateLabel.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.medium)
        dateLabel.textAlignment = .right
        
    }
    
    ///Add subviews to self
    func addViews() {
        self.contentView.addSubview(authorLabel)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(dateLabel)
    }
    
    ///Set constraints of titleLabel
    func setConstraints() {
        let margins = self.contentView.layoutMarginsGuide
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        authorLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        authorLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        authorLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -2.0).isActive = true
        authorLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.75).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentLabel.topAnchor, constant: -2.0).isActive = true
        
        contentLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        dateLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10.0).isActive = true
    }
    
}
