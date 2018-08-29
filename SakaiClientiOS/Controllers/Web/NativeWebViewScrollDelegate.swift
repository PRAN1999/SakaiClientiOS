//
//  NativeWebViewScrollDelegate.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 8/28/18.
//

import UIKit

class NativeWebViewScrollViewDelegate: NSObject, UIScrollViewDelegate {
    // MARK: - Shared delegate
    static var shared = NativeWebViewScrollViewDelegate()
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
    }
}
