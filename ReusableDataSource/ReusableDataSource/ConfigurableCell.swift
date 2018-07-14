//
//  ConfigurableCell.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//

import Foundation

public protocol ConfigurableCell: ReusableCell {
    associatedtype T
    
    func configure(_ item: T, at indexPath: IndexPath)
}
