//
//  TableViewHeaderView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/28/18.
//

import Foundation
import UIKit

class TableHeaderView : UITableViewHeaderFooterView {
    
    static var reuseIdentifier: String = "tableHeaderView"
    
    var label:UILabel!
    var imageLabel:UIImageView!
    var backgroundHeaderView: UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.label = UILabel()
        self.imageLabel = UIImageView()
        self.backgroundHeaderView = UIView(frame: self.bounds)
        self.setup()
        self.addViews()
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        self.backgroundHeaderView.backgroundColor = UIColor.lightGray
        
        self.label.font = UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.heavy)
        self.label.textColor = UIColor.red
    }
    
    func addViews() {
        self.contentView.addSubview(label)
        self.contentView.addSubview(imageLabel)
        self.backgroundView = backgroundHeaderView
    }
    
    func setupConstraints() {
        let margins = self.contentView.layoutMarginsGuide
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.imageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.label.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.label.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.label.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        //self.label.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1.0).isActive = true
        
        self.imageLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.imageLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.imageLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        self.contentView.addConstraint(NSLayoutConstraint(item: label,
                                                          attribute: .trailing,
                                                          relatedBy: .lessThanOrEqual,
                                                          toItem: imageLabel,
                                                          attribute: .leading,
                                                          multiplier: 1.0,
                                                          constant: 0.0))
    }
    
    func setImageHidden() {
        self.imageLabel.image = UIImage(named: "hide_content")
    }
    
    func setImageShow() {
        self.imageLabel.image = UIImage(named: "show_content")
    }
    
}
