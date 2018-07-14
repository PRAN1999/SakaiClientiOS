//
//  SiteController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//

import UIKit
import ReusableSource

class SiteTableSource : HideableTableSource<SiteDataProvider, SiteCell, SiteDataFetcher> {
    
    var controller:HomeController!
    
    convenience init(tableView: UITableView) {
        self.init(provider: SiteDataProvider(), fetcher: SiteDataFetcher(), tableView: tableView)
    }
    
    required init(provider: SiteDataProvider, fetcher: SiteDataFetcher, tableView: UITableView) {
        super.init(provider: provider, fetcher: fetcher, tableView: tableView)
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
        controller.navigationController?.pushViewController(classController, animated: true)
    }
}
