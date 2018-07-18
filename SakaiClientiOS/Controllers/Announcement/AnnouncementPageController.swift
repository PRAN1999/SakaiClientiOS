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
        announcementPageView = AnnouncementPageView()
        self.view = announcementPageView
        self.view.backgroundColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setAnnouncement(_ announcement: Announcement) {
        self.announcement = announcement
    }
    
    func setupView() {
        guard let item = announcement else {
            return
        }
        
        announcementPageView.titleLabel.titleLabel.text = item.title
        announcementPageView.authorLabel.titleLabel.text = item.author
        announcementPageView.dateLabel.titleLabel.text = item.dateString
        announcementPageView.setContent(attributedText: item.attributedContent)
    }

}
