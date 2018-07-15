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
    
    /// The UILabel for the name of the gradebook entry
    var titleLabel:UILabel!
    
    /// The UILabel for the points earned and max grade of the gradebook item
    var gradeLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        addViews()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Instantiate UILabels and set alignment and text-wrapping properties
    func setup() {
        gradeLabel = UILabel()
        gradeLabel.textAlignment = NSTextAlignment.right
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    }
    
    ///Add subviews to tableview contentView
    func addViews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(gradeLabel)
    }
    
    /// Constrain titleLabel and imageLabel within contentView
    func setConstraints() {
        let margins = self.contentView.layoutMarginsGuide
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        gradeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //Constrain titleLabel to top, bottom and left anchor of contentview
        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        //Constrain right of titleLabel to left anchor of gradeLabel
        titleLabel.trailingAnchor.constraint(equalTo: gradeLabel.leadingAnchor).isActive = true
        
        //Force titleLabel's width to be half of contentView
        titleLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5).isActive = true
        
        //Constrain top, bottom, and right anchors of gradeLabel to edges of contentView
        gradeLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        gradeLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        gradeLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ item: GradeItem, at indexPath: IndexPath) {
        var grade:String
        if let g = item.grade {
            grade = "\(g)"
        } else {
            grade = ""
        }
        
        titleLabel.text = item.title
        gradeLabel.text = "\(grade) / \(item.points)"
    }
}
