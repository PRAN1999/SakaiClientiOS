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
    
    var assignments:[Assignment]!
    
    var collectionDataSource:AssignmentDataSource = AssignmentDataSource()

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
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        
        let layout = AssignmentLayout()
        
        self.collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        self.collectionView.dataSource = collectionDataSource
        self.collectionView.delegate = self
        self.collectionView.register(AssignmentCell.self, forCellWithReuseIdentifier: AssignmentCell.reuseIdentifier)
        self.collectionView.backgroundColor = UIColor.white
    }
    
    func addViews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(collectionView)
    }
    
    func setConstraints() {
        
        let margins = self.contentView.layoutMarginsGuide
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        
        self.collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        self.collectionView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.75).isActive = true
        
        let constraint = NSLayoutConstraint(item: self.titleLabel,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: self.collectionView,
                                            attribute: .top,
                                            multiplier: 1.0,
                                            constant: -10.0)
        self.contentView.addConstraint(constraint)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension SiteAssignmentsCell {
    func setAssignments(list: [Assignment]) {
        self.assignments = list
        self.collectionDataSource.loadData(list: self.assignments)
        self.collectionView.reloadData()
    }
}

extension SiteAssignmentsCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("selected")
    }
    
}

extension SiteAssignmentsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.bounds.width / 3, height: collectionView.bounds.height)
        return size
    }
}
