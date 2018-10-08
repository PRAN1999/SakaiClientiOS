//
//  LoadableController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/26/18.
//

import UIKit

/// Describes UI behavior for any controller that can reload/refresh its data
@objc protocol LoadableController {
    /// A selectable action for reloading the data for a ViewController
    @objc func loadData()
}

// MARK: - Utility methods

extension LoadableController where Self: UIViewController {
    /// Configure navigation bar with action to reload data using right bar button
    func configureNavigationItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self,
                                                                 action: #selector(loadData))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: Notification.Name(rawValue: ReloadActions.reload.rawValue), object: nil)
    }

    /// Adds a loading indicator to the view and returns a callback to remove it on completion of a task
    ///
    /// Ideally as part of NetworkSourceDelegate conformance
    func addLoadingIndicator() -> (() -> Void) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let indicator = LoadingIndicator(view: view)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        let afterLoad = { [weak self] in
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            self?.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        return afterLoad
    }
}
