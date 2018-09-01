//
//  AnnouncementController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit
import ReusableSource

class AnnouncementController: UITableViewController {
    
    var announcementTableManager : AnnouncementTableManager!
    var dateActionSheet: UIAlertController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        announcementTableManager = AnnouncementTableManager(tableView: tableView)
        announcementTableManager.selectedAt.delegate(to: self) { (self, indexPath) -> Void in
            guard let announcement = self.announcementTableManager.item(at: indexPath) else {
                return
            }
            let announcementPage = AnnouncementPageController()
            announcementPage.setAnnouncement(announcement)
            self.navigationController?.pushViewController(announcementPage, animated: true)
        }
        announcementTableManager.delegate = self
        
        loadData()
        self.configureNavigationItem()
        configureActionSheet()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.addBarSwipeHider()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.removeBarSwipeHider()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureActionSheet() {
        let timer = UIImage(named: "timer")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: timer, style: .plain, target: self, action: #selector(presentFilterOptions))
        
        dateActionSheet = UIAlertController(title: "SINCE:", message: "How far back should we request announcements?", preferredStyle: .actionSheet)
        
        for option in AnnouncementTableManager.filterOptions {
            let action = UIAlertAction(title: option.0, style: .default) { [weak self] (action) in
                self?.announcementTableManager.daysBack = option.1
                self?.loadData()
            }
            dateActionSheet.addAction(action)
        }
        
        dateActionSheet.view.tintColor = AppGlobals.sakaiRed
        
        dateActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in }))
    }
    
    @objc func presentFilterOptions() {
        self.present(dateActionSheet, animated: true, completion: nil)
    }
}

extension AnnouncementController: LoadableController {
    @objc func loadData() {
        self.announcementTableManager.loadDataSourceWithoutCache()
    }
}

extension AnnouncementController: FeedController {
    @objc func swipeTarget() {
        self.setTabBarVisibility()
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
}

extension AnnouncementController: NetworkSourceDelegate {}
