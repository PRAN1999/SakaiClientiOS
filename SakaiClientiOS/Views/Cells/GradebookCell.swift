//
//  GradebookCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/13/18.
//

import UIKit
import ReusableSource

/// The table view cell to display a GradeItem in a gradebook
class GradebookCell: UITableViewCell, ConfigurableCell {
    typealias T = GradeItem
    
    let titleLabel: UILabel = {
        let titleLabel: UILabel = UIView.defaultAutoLayoutView()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.textColor = Palette.main.primaryTextColor
        return titleLabel
    }()

    let gradeLabel: UILabel = {
        let gradeLabel: UILabel = UIView.defaultAutoLayoutView()
        gradeLabel.textAlignment = NSTextAlignment.right
        gradeLabel.textColor = Palette.main.primaryTextColor
        return gradeLabel
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = Palette.main.secondaryBackgroundColor.color(withTransparency: 0.3)
        selectedBackgroundView = selectedView()

        contentView.addSubview(titleLabel)
        contentView.addSubview(gradeLabel)
    }

    private func setConstraints() {
        let margins = contentView.layoutMarginsGuide

        titleLabel.constrainToMargins(of: contentView,
                                      onSides: [.bottom, .top, .left])
        titleLabel.trailingAnchor.constraint(equalTo: gradeLabel.leadingAnchor)
                                            .isActive = true
        titleLabel.widthAnchor.constraint(equalTo: margins.widthAnchor,
                                          multiplier: 0.5).isActive = true
        gradeLabel.constrainToMargins(of: contentView,
                                      onSides: [.bottom, .top, .right])
    }

    /// Configure the GradebookCell with a GradeItem object
    ///
    /// - Parameters:
    ///   - item: The GradeItem to be used as the model for the cell
    ///   - indexPath: The indexPath at which the GradebookCell will be displayed in the UITableView
    func configure(_ item: GradeItem, at indexPath: IndexPath) {
        var grade: String
        if let itemGrade = item.grade {
            grade = itemGrade
        } else {
            grade = ""
        }
        titleLabel.text = item.title
        gradeLabel.text = "\(grade) / \(item.points)"
    }
}
