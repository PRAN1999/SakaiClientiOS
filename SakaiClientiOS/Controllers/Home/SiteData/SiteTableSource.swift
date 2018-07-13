//
//  SiteController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/11/18.
//

import UIKit

class SiteTableSource : HideableTableSource<SiteDataProvider, SiteCell, SiteDataFetcher> {
    
    var controller:HomeController!
    
    init(tableView: UITableView) {
        super.init(provider: SiteDataProvider(), fetcher: SiteDataFetcher(), tableView: tableView)
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
