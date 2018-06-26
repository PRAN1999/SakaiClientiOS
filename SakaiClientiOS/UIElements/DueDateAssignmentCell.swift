//
//  DueDateAssignmentCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/25/18.
//

import UIKit

class DueDateAssignmentCell: UITableViewCell {
    
    static let reuseIdentifier:String = "dueDateAssignmentsCell"
    
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
        let layout = HorizontalLayout()
        
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
    }
    
    func addViews() {
        self.addSubview(collectionView)
    }
    
    func setConstraints() {
        let margins = self.layoutMarginsGuide
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
        
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: 450).isActive = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setHeightConstraint(dataSource: AssignmentDataSource) {
        let list = dataSource.assignments!
        let height = CGFloat(250 * ceil(Float(list.count / 2)))
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
        
    }
}
