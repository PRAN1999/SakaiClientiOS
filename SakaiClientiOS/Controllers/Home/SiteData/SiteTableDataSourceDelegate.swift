//
//  SiteController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//

import UIKit
import ReusableSource

class SiteTableDataSourceDelegate : HideableTableSource<SiteDataProvider, SiteCell>, NetworkSource {

    typealias Fetcher = SiteDataFetcher
    
    var fetcher: SiteDataFetcher
    var controller:HomeController?
    
    convenience init(tableView: UITableView) {
        self.init(provider: SiteDataProvider(), tableView: tableView)
    }
    
    required init(provider: SiteDataProvider, tableView: UITableView) {
        fetcher = SiteDataFetcher()
        super.init(provider: provider, tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        transitionToClass(indexPath: indexPath)
    }
    
    func transitionToClass(indexPath: IndexPath) {
        let classController:ClassController = ClassController()
        guard let site:Site = item(at: indexPath) else {
            return
        }
        classController.title = site.title
        classController.setPages(pages: site.pages)
        controller?.navigationController?.pushViewController(classController, animated: true)
    }
}
