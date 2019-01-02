//
//  TermService.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/1/19.
//

import Foundation

protocol TermService {
    var termMap: [(Term, [String])] { get }
}
