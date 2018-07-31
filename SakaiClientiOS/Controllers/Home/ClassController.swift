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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.tableView.register(SiteCell.self, forCellReuseIdentifier: SiteCell.reuseIdentifier)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        
        var sitePage:SitePageController
        sitePage = page.siteType.init()
        sitePage.siteId = page.siteId
        
        guard let controller = sitePage as? UIViewController else {
            return
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setPages(pages: [SitePage]) {
        sitePages = pages
    }
}
