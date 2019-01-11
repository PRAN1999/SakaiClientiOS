//
//  Rotatable.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/6/19.
//

import Foundation

/// An empty protocol determining whether a view controller should be
/// allowed to rotate. If a ViewController conforms to this protocol, it will
/// be allowed to rotate but it is responsible for forcing the orientation
/// back to portrait on dismiss. (See WebController)
///
/// Applies to iPhone only. All controllers can rotate on iPad.
protocol Rotatable {}
