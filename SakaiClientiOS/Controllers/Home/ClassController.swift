//
//  ClassController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/11/18.
//

import UIKit

class ClassController: UITableViewController {

    private let pages: [SitePage]

    init(pages: [SitePage]) {
        self.pages = pages
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        title = "Pages"
        tableView.backgroundColor = UIColor.darkGray
        tableView.register(SiteCell.self, forCellReuseIdentifier: SiteCell.reuseIdentifier)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SiteCell.reuseIdentifier, for: indexPath) as? SiteCell else {
            fatalError("Not a Site Table View Cell")
        }
        let page: SitePage = pages[indexPath.row]
        cell.titleLabel.text = page.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let page:SitePage = pages[indexPath.row]
        
        let sitePage: SitePageController = page.siteType.init(siteId: page.siteId,
                                                             siteUrl: page.url,
                                                             pageTitle: page.title)
        
        guard let controller = sitePage as? UIViewController else {
            return
        }

        if controller is DefaultController || controller is ChatRoomController {
            hidesBottomBarWhenPushed = true
        }
        navigationController?.pushViewController(controller, animated: true)
        hidesBottomBarWhenPushed = false
    }
}
