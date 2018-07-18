//
//  AnnouncementPageView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/8/18.
//

import UIKit

class AnnouncementPageView: UIView {
    
    var titleLabel: InsetUILabel!
    var authorLabel: InsetUILabel!
    var dateLabel: InsetUILabel!
    var contentView: UITextView!

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
        titleLabel = InsetUILabel()
        titleLabel.titleLabel.numberOfLines = 0
        titleLabel.titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        //titleLabel.titleLabel.textAlignment = .center
        titleLabel.titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabel.layer.cornerRadius = 0
        
        authorLabel = InsetUILabel()
        authorLabel.titleLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        authorLabel.layer.cornerRadius = 0
        
        dateLabel = InsetUILabel()
        dateLabel.titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
        dateLabel.titleLabel.textAlignment = .right
        dateLabel.titleLabel.textColor = UIColor.white
        dateLabel.layer.cornerRadius = 0
        
        contentView = UITextView()
    }
    
    func addViews() {
        self.addSubview(titleLabel)
        self.addSubview(authorLabel)
        self.addSubview(dateLabel)
        self.addSubview(contentView)
    }
    
    func setConstraints() {
        
        let margins = self.layoutMarginsGuide
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -5).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.1).isActive = true
        
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5.0).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5.0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: authorLabel.topAnchor).isActive = true
        
        authorLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor).isActive = true
        authorLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.60).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: authorLabel.topAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: authorLabel.bottomAnchor).isActive = true
    }
    
    func setContent(attributedText: NSAttributedString?) {
        guard let text = attributedText else {
            return
        }
        
        let content = NSMutableAttributedString(attributedString: text)
        let contentRange = NSRange(location: 0, length: content.string.count)
        content.addAttribute(.font, value: UIFont.systemFont(ofSize: 16.0, weight: .regular), range: contentRange)
        
        contentView.attributedText = content
    }
}
