//
//  ResourceCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/28/18.
//

import UIKit
import ReusableSource

class ResourceCell: UITableViewCell, ReusableCell {
    typealias T = ResourceItem
    
    ///The UILabel containing the title text
    var titleLabel: UILabel!
    
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
        //Instantiate titleLabel and set attributes
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
    }
    
    ///Add subviews to self
    func addViews() {
        self.contentView.addSubview(titleLabel)
    }
    
    ///Set constraints of titleLabel
    func setConstraints() {
        let margins = self.contentView.layoutMarginsGuide
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //Constrain titleLabel to top, bottom, left, and right anchors
        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    func configure(_ item: ResourceItem, at level: Int) {
        titleLabel.text = item.title
        self.contentView.layoutMargins.left = CGFloat(level * 20)
    }
}
