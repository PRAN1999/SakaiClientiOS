//
//  NativeWebViewScrollDelegate.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/28/18.
//

import UIKit

/// A delegate to ensure any web components intended to be "native" do not
/// scroll horizontally
class NativeWebViewScrollViewDelegate: NSObject, UIScrollViewDelegate {
    // MARK: - Shared delegate
    static var shared = NativeWebViewScrollViewDelegate()

    private override init() {
        super.init()
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
    }
}
