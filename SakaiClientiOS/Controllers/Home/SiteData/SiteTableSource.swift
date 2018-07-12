//
//  SiteController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//

import UIKit

class SiteTableSource : HideableTableSource<Site, SiteCell, SiteDataFetcher> {
    
    let TABLE_CELL_HEIGHT:CGFloat = 40.0
    var controller:HomeController!
    
    init(tableView: UITableView) {
        super.init(provider: HideableDataProvider<Site>(), fetcher: SiteDataFetcher(), tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TABLE_CELL_HEIGHT
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
