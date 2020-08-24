//
//  ReusableCell.swift
//  ReusableSource
//
//  Created by Pranay Neelagiri on 7/11/18.
//  Copyright © 2018 Pranay Neelagiri. All rights reserved.
//

/// A protocol to define any class element that needs to identified
/// by a standard reuse identifier, usually for UITableViewCell and
/// UICollectionViewCell
public protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

public extension ReusableCell {
    /// To allow any class to adopt the ReusableCell protocol without any
    /// further configuration, the standard reuseIdentifier will be the
    /// class name.
    ///
    /// **Example**: The reuseIdentifier for:
    ///
    ///
    ///     class SampleTableViewCell: UITableViewCell, ReusableCell
    ///
    ///
    /// will be "SampleTableViewCell"
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
