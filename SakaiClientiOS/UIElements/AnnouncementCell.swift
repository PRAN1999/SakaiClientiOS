//
//  AnnouncmentCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/30/18.
//

import UIKit
import ReusableSource

class AnnouncementCell: UITableViewCell, ConfigurableCell {
    
    typealias T = Announcement
    
    var authorLabel: UILabel!
    var titleLabel: UILabel!
    var contentLabel:UILabel!
    var dateLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        addViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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
    
    func addViews() {
        self.contentView.addSubview(authorLabel)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(dateLabel)
    }
    
    func setConstraints() {
        let margins = self.contentView.layoutMarginsGuide
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Constrain authorLabel to top, and left anchor and constrain authorLabel right anchor to dateLabel left anchor
        authorLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        authorLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        
        // Constrain authorLabel bottom anchor to top of titleLabel
        authorLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -2.0).isActive = true
        
        // Constrain authorLabel width to 75% of cell width
        authorLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.75).isActive = true
        
        // Constrain titleLabel right and left anchor to cell right and left anchors
        // Constrain titleLabel bottom anchor to top of contentLabel
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
    
    /// Configure the AnnouncementCell with a Announcement object
    ///
    /// - Parameters:
    ///   - item: The Announcement to be used as the model for the cell
    ///   - indexPath: The indexPath at which the AnnouncementCell will be displayed in the UITableView
    func configure(_ item: Announcement, at indexPath: IndexPath) {
        authorLabel.text = item.author
        titleLabel.text = item.title
        
        if let content = item.attributedContent {
            let mutableContent = NSMutableAttributedString(attributedString: content)
            let contentRange = NSRange(location: 0, length: content.string.count)
            mutableContent.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.light), range: contentRange)
            contentLabel.attributedText = mutableContent
        }
        
        dateLabel.text = item.dateString
    }
}
