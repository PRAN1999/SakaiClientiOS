//
//  TermService.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/1/19.
//

import Foundation

/// A service that provides allows access to the global Term map
protocol TermService {
    var termMap: [(Term, [String])] { get }
}
