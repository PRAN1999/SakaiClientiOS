//
//  FloatingHeaderCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/3/18.
//

import UIKit

/// The "floating" header used in the gradebook view
class FloatingHeaderCell: UITableViewCell {

    static var reuseIdentifier: String = "floatingHeaderCell"
    
    /// The UILabel holding the title of the Site
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
        super.init(coder: aDecoder)
    }
    
    
    /// Instantiate and setup titleLabel
    func setup() {
        self.backgroundColor = AppGlobals.SAKAI_RED
        
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight.light)
        
        self.isHidden = true
    }
    
    /// Add titleLabel to contentView
    func addViews() {
        self.contentView.addSubview(titleLabel)
    }
    
    /// Constrain titleLabel to edges
    func setConstraints() {
        let margins = self.contentView.layoutMarginsGuide
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 20.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1.0).isActive = true
    }
    
    /// Set the text of the titleLabel
    ///
    /// - Parameter title: The title text to set
    func setTitle(title: String?) {
        titleLabel.text = title
    }

    
    /// Make the floating header visible in the specified frame
    ///
    /// - Parameter frame: The frame in which the cell should be visible
    func setFrameAndMakeVisible(frame: CGRect) {
        self.frame = frame
        self.isHidden = false
    }
}
