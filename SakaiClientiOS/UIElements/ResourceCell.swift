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
    var titleLabel: InsetUILabel!
    var leftBorder: UIView!
    var sizeLabel: UILabel!
    var spaceView: UIView!
    
    var needsSizeLabel = false
    
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
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        titleLabel = InsetUILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.light)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.backgroundColor = UIColor.clear
        
        leftBorder = UIView()
        
        sizeLabel = UILabel()
        sizeLabel.backgroundColor = UIColor.lightGray
        sizeLabel.textAlignment = .center
        sizeLabel.textColor = UIColor.white
        sizeLabel.layer.masksToBounds = true
        
        spaceView = UIView()
    }
    
    func addViews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(leftBorder)
        self.contentView.addSubview(sizeLabel)
        self.contentView.addSubview(spaceView)
    }
    
    func setConstraints() {
        let margins = self.contentView.layoutMarginsGuide
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        leftBorder.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        
        leftBorder.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        leftBorder.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        leftBorder.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        leftBorder.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        leftBorder.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.015).isActive = true
        
        titleLabel.trailingAnchor.constraint(equalTo: sizeLabel.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        sizeLabel.trailingAnchor.constraint(equalTo: spaceView.leadingAnchor).isActive = true
        sizeLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        sizeLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        sizeLabel.widthAnchor.constraint(equalTo: sizeLabel.heightAnchor, multiplier: 1.0).isActive = true
        
        spaceView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        spaceView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        spaceView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    func configure(_ item: ResourceItem, at level: Int, isExpanded: Bool) {
        titleLabel.titleLabel.text = item.title
        leftBorder.backgroundColor = getColor(for: level)
        let left = CGFloat(level == 0 ? 0 : level * 20 + 10)
        self.contentView.layoutMargins.left = left
        switch(item.type) {
        case .collection:
            self.selectionStyle = .none
            self.accessoryType = .none
            sizeLabel.text = String(item.numChildren)
            sizeLabel.isHidden = false
            if isExpanded {
                sizeLabel.backgroundColor = getColor(for: level)
            } else {
                sizeLabel.backgroundColor = UIColor.lightGray
            }
            break
        case .resource:
            self.selectionStyle = .default
            self.accessoryType = .disclosureIndicator
            sizeLabel.isHidden = true
            break
        }
    }
    
    func getColor(for level:Int) -> UIColor {
        let mod = level % 4
        switch(mod) {
        case 0:
            return UIColor(red: 199.0 / 256.0, green: 26.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
        case 1:
            return UIColor(red: 199.0 / 256.0, green: 66.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
        case 2:
            return UIColor(red: 199.0 / 256.0, green: 104.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
        case 3:
            return UIColor(red: 199.0 / 256.0, green: 142.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
        default:
            return UIColor.black
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutSubviews()
        sizeLabel.layer.cornerRadius = sizeLabel.bounds.size.height / 2
    }
    
    override func prepareForReuse() {
        sizeLabel.backgroundColor = UIColor.lightGray
    }
}
