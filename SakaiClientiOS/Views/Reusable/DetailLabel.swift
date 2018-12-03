//
//  DetailLabel.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/20/18.
//

import UIKit

/// A UILabel to represent any key-value pair
class DetailLabel: UILabel {

    let titleLabel: UILabel = {
        let titleLabel: UILabel = UIView.defaultAutoLayoutView()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        return titleLabel
    }()

    let detailLabel: UILabel = {
        let detailLabel: UILabel = UIView.defaultAutoLayoutView()
        detailLabel.textAlignment = NSTextAlignment.right
        return detailLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1

        addSubview(titleLabel)
        addSubview(detailLabel)
    }

    private func setConstraints() {
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
