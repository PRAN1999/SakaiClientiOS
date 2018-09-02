//
//  AssignmentTableCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/10/18.
//

import UIKit
import ReusableSource

/// A TableViewCell to represent a group of Assignment objects, either for a specific class or for an entire Term
class AssignmentTableCell: UITableViewCell, ConfigurableCell {
    typealias T = [Assignment]

    var titleLabel: UILabel!

    var collectionView: UICollectionView!
    var manager: AssignmentCollectionManager!

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
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.black
        titleLabel.layer.cornerRadius = 5
        titleLabel.layer.masksToBounds = true

        // Create a horizontal flow layout so the collectionView can scroll horizontally
        let layout = HorizontalLayout()

        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white

        //Construct Data Source and Delegate for collectionView as an AssignmentCollectionSource object
        manager = AssignmentCollectionManager(collectionView: collectionView)
    }

    func addViews() {
        self.addSubview(titleLabel)
        self.addSubview(collectionView)
    }

    func setConstraints() {
        let margins = self.layoutMarginsGuide

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        // Constrain titleLabel to top, left, and right margins of cell
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true

        // Constrain titleLabel bottom anchor to top of collectionView
        titleLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -10.0).isActive = true

        // Constrain collectionView to left, right and bottom of cell
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true

        // Ensure the collectionView takes up 80% of the cell
        collectionView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.8).isActive = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        // Force the cell to be at least 280 pixels in height
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: 280).isActive = true
    }

    /// Configure the AssignmentTableCell with a [Assignment] object
    ///
    /// - Parameters:
    ///   - item: The [Assignment] to be used as the model for the cell
    ///   - indexPath: The indexPath at which the AssignmentTableCell will be displayed in the UITableView
    func configure(_ item: [Assignment], at indexPath: IndexPath) {
        guard item.count > 0 else {
            return
        }
        let siteId = item[0].siteId
        let title = SakaiService.shared.siteTitleMap[siteId]
        titleLabel.text = title

        manager.loadItems(payload: item)
        manager.reloadData()
    }
}
