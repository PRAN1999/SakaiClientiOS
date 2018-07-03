//
//  HomeController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/23/18.

import Foundation
import UIKit

class HomeController: CollapsibleSectionController {
    
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
        classController.title = site.getTitle()
        classController.setPages(pages: site.getPages())
        self.navigationController?.pushViewController(classController, animated: true)
    }
}
