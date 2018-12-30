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

    private var pendingIndex: Int? = 0

    private var pages: [UIViewController?]
    private let assignments: [Assignment]
    private let start: Int

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
        let pageView = pageController.view!
        UIView.constrainChildToEdges(child: pageView, parent: view)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the LNPopupController instance for the NavigationController
        setPopupURL(viewControllerIndex: start)
        webController.title = "DRAG TO SUBMIT"
        navigationController?.popupInteractionStyle = .default
        navigationController?.popupBar.backgroundStyle = .regular
        navigationController?.popupBar.barStyle = .compact

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false;
        tabBarController?.tabBar.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.presentPopupBar(withContentViewController: webController, animated: true, completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.dismissPopupBar(animated: true, completion: nil)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        tabBarController?.tabBar.isHidden = false
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
    
    /// Create a controller for an Assignment page view and insert it into the
    /// managed Assignment array for the page controller
    ///
    /// - Parameters:
    ///   - assignment: the assignment to display in the newly constructed controller
    ///   - index: the index of the Assignment in the Assignment model array
    private func setPage(assignment: Assignment, index: Int) {
        let page = AssignmentPageController(assignment: assignment)
        page.delegate = self
        pages[index] = page
    }
    
    /// When transitioning from one Assignment page to the next, the URL for the current
    /// Assignment is assigned to the WebController contained in the popup bar
    ///
    /// - Parameter viewControllerIndex: the index of the current Assignment
    private func setPopupURL(viewControllerIndex: Int) {
        let assignment = assignments[viewControllerIndex]
        guard let url = assignment.siteURL else {
            return
        }
        webController.setURL(url: URL(string: url)!)
        webController.needsNav = false
        webController.shouldLoad = true
        webController.openInSafari = { [weak self] url in
            guard let url = url, url.absoluteString.contains("http") else {
                return
            }
            let safariController = SFSafariViewController(url: url)
            self?.navigationController?.dismissPopupBar(animated: true, completion: nil)
            self?.tabBarController?.present(safariController, animated: true, completion: nil)
        }
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
        childView?.layoutIfNeeded()
    }
}
