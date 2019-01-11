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

// MARK: - Utility methods

extension LoadableController where Self: UIViewController {
    /// Configure navigation bar with action to reload data using right bar
    /// button
    func configureNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                            target: self,
                                                            action: #selector(loadData))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadData),
            name: Notification.Name(rawValue: ReloadActions.reload.rawValue),
            object: nil
        )
    }

    func addLoadingIndicator() -> (() -> Void) {
        navigationItem.rightBarButtonItem?.isEnabled = false
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
