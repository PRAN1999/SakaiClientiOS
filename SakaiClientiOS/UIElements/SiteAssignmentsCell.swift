//
//  SiteAssignmentsCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/10/18.
//

import UIKit

class SiteAssignmentsCell: UITableViewCell {
    
    static let reuseIdentifier:String = "siteAssignmentsCell"
    
    var titleLabel: UILabel!
    var collectionView: UICollectionView!
    var assignmentDataSource:AssignmentDataSource!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
        self.addViews()
        self.setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        self.titleLabel = UILabel()
        self.titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.textAlignment = .center
        self.titleLabel.backgroundColor = UIColor.black
        self.titleLabel.layer.cornerRadius = 5
        self.titleLabel.layer.masksToBounds = true
        
        let layout = AssignmentLayout()
        
        self.collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        self.collectionView.backgroundColor = UIColor.white
    }
    
    func addViews() {
        self.addSubview(titleLabel)
        self.addSubview(collectionView)
    }
    
    func setConstraints() {
        let margins = self.layoutMarginsGuide
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        
        self.collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: 300).isActive = true
        self.collectionView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.8).isActive = true
        
        let constraint = NSLayoutConstraint(item: self.titleLabel,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: self.collectionView,
                                            attribute: .top,
                                            multiplier: 1.0,
                                            constant: -10.0)
        self.addConstraint(constraint)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
