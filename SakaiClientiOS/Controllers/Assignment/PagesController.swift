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

    var pageControl: UIPageControl!
    var pageControlView: UIView!
    var pageController: UIPageViewController!

    // Even when the Assignment displayed changes, the popup controller instance will
    // be the same but the popup URL will change
    var webController: WebController!
    var popupController: WebViewNavigationController!
    
    var pages: [UIViewController?] = []
    var assignments: [Assignment] = []
    var start: Int = 0
    var pendingIndex: Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeControllers()
        setPage(assignment: self.assignments[start], index: start)

        // Configure the LNPopupController instance for the NavigationController
        setPopupURL(viewControllerIndex: start)
        webController.title = "DRAG TO SUBMIT"
        self.navigationController?.popupInteractionStyle = .default
        self.navigationController?.popupBar.backgroundStyle = .regular
        self.navigationController?.popupBar.barStyle = .compact
        setup()
    }
    
    func initializeControllers() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        webController = WebController()
        popupController = WebViewNavigationController(rootViewController: webController)
        
        pageControl = UIPageControl()
        pageControlView = UIView()
    }
    
    /// Setup UI page control and full page container layout
    func setup() {
        guard let startPage = pages[start] else {
            return
        }
        
        pageController.setViewControllers([startPage], direction: .forward, animated: false, completion: nil)
        
        let pageView = pageController.view!
        view.addSubview(pageView)
        
        pageControl.tintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = AppGlobals.sakaiRed
        
        pageControlView.addSubview(pageControl)
        
        self.navigationItem.titleView = pageControlView
        
        pageView.translatesAutoresizingMaskIntoConstraints = false
        pageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        pageController.dataSource = self
        pageController.delegate = self
        
        pageControl.numberOfPages = assignments.count
        pageControl.currentPage = start
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false;
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.presentPopupBar(withContentViewController: popupController, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.dismissPopupBar(animated: true, completion: nil)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        self.tabBarController?.tabBar.isHidden = false
    }
    
    /// Set the data for the page controller. Used when constructing instance before transition
    ///
    /// - Parameters:
    ///   - assignments: assignments to display in page controller
    ///   - start: the assignment index to display on first transition
    func setAssignments(assignments: [Assignment], start: Int) {
        pages = [UIViewController?](repeating: nil, count: assignments.count)
        self.assignments = assignments
        self.start = start
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            }
        }
    }
    
    /// Create a controller for an Assignment page view and insert it into the
    /// managed Assignment array for the page controller
    ///
    /// - Parameters:
    ///   - assignment: the assignment to display in the newly constructed controller
    ///   - index: the index of the Assignment in the Assignment model array
    func setPage(assignment: Assignment, index: Int) {
        let page = AssignmentPageController()
        page.assignment = assignment
        page.delegate = self
        pages[index] = page
    }
    
    /// When transitioning from one Assignment page to the next, the URL for the current
    /// Assignment is assigned to the WebController contained in the popup bar
    ///
    /// - Parameter viewControllerIndex: the index of the current Assignment
    func setPopupURL(viewControllerIndex: Int) {
        let assignment = assignments[viewControllerIndex]
        guard let url = assignment.siteURL else {
            return
        }
        webController.setURL(url: URL(string: url)!)
        webController.shouldLoad = true
        webController.needsNav = false
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
