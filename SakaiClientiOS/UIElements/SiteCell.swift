//
//  SiteCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/27/18.
//

import UIKit
import ReusableSource

/// The Tableview Cell to display Site titles
class SiteCell: UITableViewCell, ConfigurableCell {
    // swiftlint:disable type_name
    typealias T = Site
    var titleLabel: UILabel!

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
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    }

    func addViews() {
        self.contentView.addSubview(titleLabel)
    }

    func setConstraints() {
        let margins = self.contentView.layoutMarginsGuide
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        //Constrain titleLabel to top, bottom, left, and right anchors
        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 20.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1.0).isActive = true
    }

    func configure(_ item: Site, at indexPath: IndexPath) {
        titleLabel.text = item.title
    }
}
