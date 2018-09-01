//
//  AnnouncementPageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/8/18.
//

import UIKit

class AnnouncementPageController: UIViewController {
    
    var announcementPageView: AnnouncementPageView!
    var announcement: Announcement?
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupView() {
        guard let item = announcement else {
            return
        }
        
        announcementPageView = AnnouncementPageView()
        self.view.addSubview(announcementPageView)
        
        guard let margins = self.view else {
            return
        }
        
        announcementPageView.translatesAutoresizingMaskIntoConstraints = false
        
        announcementPageView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        announcementPageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        announcementPageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        announcementPageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        announcementPageView.messageView.delegate = self
        
        announcementPageView.titleLabel.titleLabel.text = item.title
        announcementPageView.authorLabel.titleLabel.text = item.author
        announcementPageView.dateLabel.titleLabel.text = item.dateString
        let resourceStrings = item.attachments?.map { $0.toAttributedString() }
        announcementPageView.setMessage(attributedText: item.attributedContent, resources: resourceStrings)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setAnnouncement(_ announcement: Announcement) {
        self.announcement = announcement
    }
}
