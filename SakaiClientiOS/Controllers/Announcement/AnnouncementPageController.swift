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
        self.configureNavigationTapRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureBarsForTaps(appearing: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.configureBarsForTaps(appearing: false)
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
        
        announcementPageView.contentView.delegate = self
        self.configureNavigationTapRecognizer(for: announcementPageView.contentView.tapRecognizer)
        
        announcementPageView.titleLabel.titleLabel.text = item.title
        announcementPageView.authorLabel.titleLabel.text = item.author
        announcementPageView.dateLabel.titleLabel.text = item.dateString
        announcementPageView.setContent(attributedText: item.attributedContent, resources: item.attachments)
    }

}
