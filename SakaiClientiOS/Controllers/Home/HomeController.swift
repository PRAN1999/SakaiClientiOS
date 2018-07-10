//
//  HomeController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/23/18.

import Foundation
import UIKit

class HomeController: BaseHideableTableViewController {
    
    let TABLE_CELL_HEIGHT:CGFloat = 40.0
    
    var siteDataSource: SiteDataSource!
    
    required init?(coder aDecoder: NSCoder) {
        siteDataSource = SiteDataSource()
        super.init(coder: aDecoder, dataSource: siteDataSource)
        siteDataSource.controller = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.title = "Classes"
        RequestManager.shared.toReload = false
        super.tableView.register(SiteCell.self, forCellReuseIdentifier: SiteCell.reuseIdentifier)
        super.tableView.register(TermHeader.self, forHeaderFooterViewReuseIdentifier: TermHeader.reuseIdentifier)
        self.setupSearchBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TABLE_CELL_HEIGHT
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        transitionToClass(indexPath: indexPath)
    }
    
    func transitionToClass(indexPath: IndexPath) {
        let classController:ClassController = ClassController()
        let site:Site = siteDataSource.sites[indexPath.section][indexPath.row]
        classController.title = site.title
        classController.setPages(pages: site.pages)
        self.navigationController?.pushViewController(classController, animated: true)
    }
}

extension HomeController: SearchableController {
    var searchableDataSource: SearchableDataSource {
        get {
            return siteDataSource
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        print(text)
        searchableDataSource.searchAndFilter(for: text)
    }
}
