//
//  DetailLabel.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/20/18.
//

import UIKit

class DetailLabel: UILabel {
    
    var titleLabel:UILabel!
    var detailLabel:UILabel!

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
        self.detailLabel = UILabel()
        self.detailLabel.textAlignment = NSTextAlignment.right
        
        self.titleLabel = UILabel()
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    }
    
    func addViews() {
        self.addSubview(titleLabel)
        self.addSubview(detailLabel)
    }
    
    func setConstraints() {
        let margins = self.layoutMarginsGuide
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.detailLabel.leadingAnchor).isActive = true
        self.titleLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5)
        
        self.detailLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.detailLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.detailLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    func setKeyVal(key: String, val: String) {
        self.titleLabel.text = key
        self.detailLabel.text = val
    }
    
}
