//
//  SiteAssignmentsCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/10/18.
//

import UIKit
import ReusableDataSource

class AssignmentTableCell: UITableViewCell, ConfigurableCell {
    
    typealias T = [Assignment]
    
    var titleLabel: UILabel!
    var collectionView: UICollectionView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        addViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.black
        titleLabel.layer.cornerRadius = 5
        titleLabel.layer.masksToBounds = true
        
        let layout = HorizontalLayout()
        
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
    }
    
    func addViews() {
        self.addSubview(titleLabel)
        self.addSubview(collectionView)
    }
    
    func setConstraints() {
        let margins = self.layoutMarginsGuide
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -10.0).isActive = true
        
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.8).isActive = true
        collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
        
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: 280).isActive = true
    }

    func configure(_ item: [Assignment], at indexPath: IndexPath) {
        
    }
}
