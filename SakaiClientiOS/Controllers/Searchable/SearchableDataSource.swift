//
//  SearchableDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/15/18.
//

import Foundation

protocol SearchableDataSource {
    func searchAndFilter(for text: String)
}
