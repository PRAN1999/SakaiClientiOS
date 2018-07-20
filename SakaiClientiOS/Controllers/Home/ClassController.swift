//
//  ClassController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/11/18.
//

import UIKit

class ClassController: UITableViewController {

    var sitePages:[SitePage] = [SitePage]()
    var siteTitle: String?
    var numSections = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.tableView.register(SiteCell.self, forCellReuseIdentifier: SiteCell.reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return numSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sitePages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SiteCell.reuseIdentifier, for: indexPath) as? SiteCell else {
            fatalError("Not a Site Table View Cell")
        }
        let page:SitePage = sitePages[indexPath.row]
        cell.titleLabel.text = page.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let page:SitePage = self.sitePages[indexPath.row]
        
        var controller:UIViewController
        
        switch(page.siteType) {
        case is SiteGradebookController.Type:
            controller = SiteGradebookController()
            let gradePageController = controller as! SiteGradebookController
            gradePageController.siteId = page.siteId
            break
        case is SiteAnnouncementController.Type:
            controller = SiteAnnouncementController()
            let announcementPageController = controller as! SiteAnnouncementController
            announcementPageController.siteId = page.siteId
        default:
            controller = DefaultController()
            print("Is Default")
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setPages(pages: [SitePage]) {
        sitePages = pages
    }
}
