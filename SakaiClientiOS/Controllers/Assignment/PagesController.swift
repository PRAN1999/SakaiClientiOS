//
//  PagesController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/17/18.
//

import UIKit
import LNPopupController
import SafariServices

/// The container view controller allowing pagination between multiple Assignments
class PagesController: UIViewController {

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.tintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = AppGlobals.sakaiRed
        return pageControl
    }()

    private let pageControlView = UIView()
    private let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    // Even when the current Assignment changes, the popup controller instance will
    // be the same but the popup URL will change
    private let webController = WebController()
    private lazy var popupController = WebViewNavigationController(rootViewController: webController)
    private let submitPopupBarController = SubmitPopupBarController()

    private var pendingIndex: Int? = 0

    private var pages: [UIViewController?]
    private let assignments: [Assignment]
    private let start: Int

    private var bottomConstraint: NSLayoutConstraint?

    weak var delegate: PageDelegate?

    init(assignments: [Assignment], start: Int) {
        self.assignments = assignments
        self.start = start
        pages = [UIViewController?](repeating: nil, count: assignments.count)
        super.init(nibName: nil, bundle: nil)
        setPage(assignment: assignments[start], index: start)
    }

    override func loadView() {
        view = UIView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        (tabBarController as? TabController)?.popupController = webController

        let pageView = pageController.view!
        bottomConstraint = UIView.constrainChildToEdgesAndBottomMargin(child: pageView, parent: view)

        // Configure the LNPopupController instance for the NavigationController
        setPopupURL(viewControllerIndex: start)

        tabBarController?.popupInteractionStyle = .default
        tabBarController?.popupBar.backgroundStyle = .regular
        tabBarController?.popupBar.customBarViewController = submitPopupBarController

        submitPopupBarController.titleLabel.text = "DRAG TO SUBMIT"

        guard let startPage = pages[start] else {
            return
        }
        pageController.setViewControllers([startPage], direction: .forward, animated: false, completion: nil)
        pageController.dataSource = self
        pageController.delegate = self

        pageControl.numberOfPages = assignments.count
        pageControl.currentPage = start
        pageControlView.addSubview(pageControl)
        navigationItem.titleView = pageControlView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false;
        guard let tabBarController = tabBarController as? TabController else {
            return
        }
        if tabBarController.shouldOpenPopup {
            tabBarController.presentPopupBar(withContentViewController: popupController,
                                             openPopup: true, animated: true, completion: nil)
            tabBarController.shouldOpenPopup = false
        } else {
            tabBarController.presentPopupBar(withContentViewController: popupController,
                                             animated: true, completion: nil)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        tabBarController?.dismissPopupBar(animated: true, completion: nil)
    }

    override func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let res = super.textView(textView, shouldInteractWith: URL, in: characterRange)
        hidesBottomBarWhenPushed = true
        return res
    }
}

extension PagesController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        setPopupURL(viewControllerIndex: viewControllerIndex)

        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }

        if pages[previousIndex] == nil {
            setPage(assignment: assignments[previousIndex], index: previousIndex)
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        setPopupURL(viewControllerIndex: viewControllerIndex)

        let nextIndex = viewControllerIndex + 1
        let assignmentsCount = assignments.count
        
        guard nextIndex < assignmentsCount else {
            return nil
        }
        if pages[nextIndex] == nil {
            setPage(assignment: assignments[nextIndex], index: nextIndex)
        }
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = pages.index(of: pendingViewControllers.first)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let index = pendingIndex {
                pageControl.currentPage = index
                delegate?.pageController(self, didMoveToIndex: index)
            }
        }
    }

    private func setPage(assignment: Assignment, index: Int) {
        let page = AssignmentPageController(assignment: assignment)
        page.textViewDelegate = self
        page.scrollViewDelegate = self
        pages[index] = page
    }

    private func setPopupURL(viewControllerIndex: Int) {
        let assignment = assignments[viewControllerIndex]
        guard let url = URL(string: assignment.siteURL) else {
            return
        }
        webController.setURL(url: url)
        webController.needsNav = false
        webController.shouldLoad = true
    }
}

extension PagesController: Animatable {
    var containerView: UIView? {
        return view
    }

    var childView: UIView? {
        return pageController.view
    }

    func dismissingView(sizeAnimator: UIViewPropertyAnimator, fromFrame: CGRect, toFrame: CGRect) {
        childView?.layer.cornerRadius = AssignmentCell.cornerRadius
        childView?.layer.borderWidth = 0.5
        childView?.layer.borderColor = UIColor.lightText.cgColor
        childView?.layoutIfNeeded()

        bottomConstraint?.isActive = false
        childView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
