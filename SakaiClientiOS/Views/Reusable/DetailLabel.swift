//
//  DetailLabel.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/20/18.
//

import UIKit

/// A UILabel to represent any key-value pair
class DetailLabel: UILabel {

    var titleLabel: UILabel!
    var detailLabel: UILabel!
    
    var shouldSetConstraints = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        if shouldSetConstraints {
            setConstraints()
            shouldSetConstraints = false
        }
        super.updateConstraints()
    }

    func setup() {
        detailLabel = UILabel()
        detailLabel.textAlignment = NSTextAlignment.right

        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping

        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        setNeedsUpdateConstraints()
    }

    func addViews() {
        self.addSubview(titleLabel)
        self.addSubview(detailLabel)
    }

    func setConstraints() {
        let margins = self.layoutMarginsGuide

        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: detailLabel.leadingAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5)

        detailLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        detailLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }

    /// Set the key-value text of the view
    ///
    /// - Parameters:
    ///   - key: The key string in the key-value pair
    ///   - val: A value to be associated with the key
    func setKeyVal(key: String, val: Any?) {
        titleLabel.text = key
        guard let value = val else {
            return
        }
        detailLabel.text = "\(value)"
    }
}
