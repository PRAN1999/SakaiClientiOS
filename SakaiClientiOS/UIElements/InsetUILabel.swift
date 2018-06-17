//
//  InsetTextBackgroundView.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/12/18.
//

import UIKit

class InsetUILabel: UILabel, UIGestureRecognizerDelegate {

    var titleLabel:UILabel!
    var tapRecognizer: UITapGestureRecognizer!
    
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
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.numberOfLines = 2
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 11.0, weight: UIFont.Weight.light)
        
        self.backgroundColor = UIColor(red: 199 / 255.0, green: 37 / 255.0, blue: 78 / 255.0, alpha: 1.0)
        
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
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
    
    func setText(text:String?) {
        self.titleLabel.text = text
    }
    
    func setAttributedText(text: NSAttributedString?) {
        self.titleLabel.attributedText = text
        
    }
}
