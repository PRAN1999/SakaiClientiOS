//
//  AssignmentTitleCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 11/8/18.
//

import Foundation
import UIKit
import ReusableSource

class AssignmentTitleCell: UITableViewCell, ConfigurableCell {
    typealias T = [Assignment]

    var titleLabel: UILabel!
    
    var shouldSetConstraints = true

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        addViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        if shouldSetConstraints {
            setConstraints()
            shouldSetConstraints = false
        }
        super.updateConstraints()
    }

    func setup() {
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.black

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        setNeedsUpdateConstraints()
    }

    func addViews() {
        self.contentView.addSubview(titleLabel)
    }

    func setConstraints() {

        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 56).isActive = true
    }

    func configure(_ item: [Assignment], at indexPath: IndexPath) {
        guard item.count > 0 else {
            return
        }
        let siteId = item[0].siteId
        let title = SakaiService.shared.siteTitleMap[siteId]
        titleLabel.text = title
    }
}
