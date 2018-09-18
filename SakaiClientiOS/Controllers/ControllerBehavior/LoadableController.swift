//
//  LoadableController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/26/18.
//

import UIKit

/// Describes UI behavior for any controller that can reload/refresh its data
@objc protocol LoadableController {
    @objc func loadData()
}

extension LoadableController where Self: UIViewController {
    func configureNavigationItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self,
                                                                 action: #selector(loadData))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: Notification.Name(rawValue: "reload"), object: nil)
    }

    /// Adds a loading indicator to the view and returns a callback to remove it on completion of a task
    ///
    /// Ideally as part of NetworkSourceDelegate conformance
    func addLoadingIndicator() -> (() -> Void) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let indicator = LoadingIndicator(view: view)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        let afterLoad = {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        return afterLoad
    }
}
