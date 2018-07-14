//
//  ReusableCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//

public protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

public extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
