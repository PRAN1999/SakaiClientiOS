//
//  TableViewHeaderView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/28/18.
//

import Foundation
import UIKit

class TableHeaderView : UITableViewHeaderFooterView {
    
    var label:UILabel!
    var backgroundHeaderView: UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.label = UILabel()
        self.backgroundHeaderView = UIView(frame: self.bounds)
        self.setup()
        self.addViews()
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        self.backgroundHeaderView.backgroundColor = UIColor.lightGray
        
        self.label.font = UIFont.systemFont(ofSize: 25.0, weight: UIFont.Weight.heavy)
        self.label.textColor = UIColor.red
    }
    
    func addViews() {
        self.addSubview(label)
        self.backgroundView = backgroundHeaderView
    }
    
    func setupConstraints() {
        
        let margins = self.layoutMarginsGuide
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1.0).isActive = true
    }
    
}
