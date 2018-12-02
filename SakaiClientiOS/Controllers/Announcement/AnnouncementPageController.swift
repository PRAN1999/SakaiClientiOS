//
//  AnnouncementPageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/8/18.
//

import UIKit

class AnnouncementPageController: UIViewController {
    
    var announcementPageView: PageView<AnnouncementPageView>!
    var announcement: Announcement

    init(announcement: Announcement) {
        self.announcement = announcement
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        announcementPageView.scrollView.configure(announcement: announcement)
        announcementPageView.scrollView.messageView.delegate = self
    }
}
