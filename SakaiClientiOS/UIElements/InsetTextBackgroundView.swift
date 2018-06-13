//
//  InsetTextBackgroundView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/12/18.
//

import UIKit

class InsetTextBackgroundView: UIView {

    var titleLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.addViews()
        self.setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.titleLabel = UILabel()
        self.titleLabel.numberOfLines = 2
        self.titleLabel.lineBreakMode = .byCharWrapping
        self.titleLabel.font = UIFont.systemFont(ofSize: 11.0, weight: UIFont.Weight.light)
        
        self.backgroundColor = UIColor.red
        self.layer.cornerRadius = 5
    }
    
    func addViews() {
        self.addSubview(titleLabel)
    }
    
    func setConstraints() {
        let margins = self.layoutMarginsGuide
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    func setText(text:String) {
        self.titleLabel.text = text
    }
    
}
