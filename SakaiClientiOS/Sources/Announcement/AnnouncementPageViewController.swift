//
//  AnnouncementPageViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/8/18.
//

import UIKit

class AnnouncementPageViewController: UIViewController {
    
    var announcementPageView: PageView<AnnouncementPageView> = PageView(frame: .zero)
    
    private let announcement: Announcement

    init(announcement: Announcement) {
        self.announcement = announcement
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = announcementPageView
        view.backgroundColor = Palette.main.primaryBackgroundColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        announcementPageView.scrollView.configure(announcement: announcement)
        announcementPageView.scrollView.messageView.delegate = self
        navigationController?.isNavigationBarHidden = false
    }
}
