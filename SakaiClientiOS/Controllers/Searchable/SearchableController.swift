//
//  SearchController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/9/18.
//

import UIKit

protocol SearchableController: UISearchResultsUpdating {
    
    var searchableDataSource: SearchableDataSource { get }
}

extension SearchableController where Self:UIViewController {
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
    }
}
