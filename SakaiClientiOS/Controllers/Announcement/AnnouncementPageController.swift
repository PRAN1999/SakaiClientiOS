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
        self.navigationController?.barHideOnTapGestureRecognizer.addTarget(self, action: #selector(hideToolBar))
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.hidesBarsOnTap = false
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func hideToolBar() {
        self.navigationController?.isToolbarHidden = true
    }
    
    @objc func hideNavBar() {
        hideToolBar()
        announcementPageView.contentView.selectedTextRange = nil
        guard let hidden = self.navigationController?.isNavigationBarHidden else {
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.isNavigationBarHidden = !hidden
        }
    }
    
    func setAnnouncement(_ announcement: Announcement) {
        self.announcement = announcement
    }
    
    func setupView() {
        guard let item = announcement else {
            return
        }
        
        announcementPageView.contentView.delegate = self
        announcementPageView.contentView.tapRecognizer.addTarget(self, action: #selector(hideNavBar))
        
        announcementPageView.titleLabel.titleLabel.text = item.title
        announcementPageView.authorLabel.titleLabel.text = item.author
        announcementPageView.dateLabel.titleLabel.text = item.dateString
        announcementPageView.setContent(attributedText: item.attributedContent, resources: item.attachments)
    }

}
