//
//  FloatingHeaderCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/3/18.
//

import UIKit

class FloatingHeaderCell: UITableViewCell {

    static var reuseIdentifier: String = "floatingHeaderCell"
    
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
        self.backgroundColor = AppGlobals.SAKAI_RED
        
        self.titleLabel = UILabel()
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        
        self.isHidden = true
    }
    
    func addViews() {
        self.contentView.addSubview(titleLabel)
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
    
    func setTitle(title: String?) {
        self.titleLabel.text = title
    }

    func setFrameAndMakeVisible(frame: CGRect) {
        self.frame = frame
        self.isHidden = false
    }
}
