//
//  AnnouncementPageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/8/18.
//

import UIKit

class AnnouncementPageController: UIViewController {
    
    var announcementPageView: PageView<AnnouncementPageView>!
    var announcement: Announcement?
    
    override func loadView() {
        self.announcementPageView = PageView(frame: .zero)
        self.view = announcementPageView
        self.view.backgroundColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupView() {
        guard let announcement = announcement else {
            return
        }

        announcementPageView.scrollView.configure(announcement: announcement)
        
        announcementPageView.scrollView.messageView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setAnnouncement(_ announcement: Announcement) {
        self.announcement = announcement
    }
}
