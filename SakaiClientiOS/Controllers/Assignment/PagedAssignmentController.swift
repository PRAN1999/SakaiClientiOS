//
//  PagedAssignmentController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/17/18.
//

import UIKit
import LNPopupController

class PagedAssignmentController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    var pageController:UIPageViewController!
    var pages: [UIViewController?]!
    var webController: WebController
    var popupController: WebViewNavigationController!
    var assignments: [Assignment]!
    
    var start:Int = 0
    var pendingIndex:Int? = 0
    
    required init?(coder aDecoder: NSCoder) {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pages = [UIViewController]()
        assignments = [Assignment]()
        webController = WebController()
        popupController = WebViewNavigationController(rootViewController: webController)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupController.title = "DRAG TO SUBMIT"
        
        self.popupInteractionStyle = .default
        self.popupBar.backgroundStyle = .regular
        self.popupBar.barStyle = .compact
        
        self.navigationController?.barHideOnTapGestureRecognizer.addTarget(self, action: #selector(hideToolBar))
        self.navigationController?.isNavigationBarHidden = true
        
        setup()
    }
    
    func setup() {
        guard let startPage = pages[start] else {
            return
        }
        pageController.setViewControllers([startPage], direction: .forward, animated: false, completion: nil)
        
        let pageView = pageController.view!
        view.addSubview(pageView)
        pageView.translatesAutoresizingMaskIntoConstraints = false
        
        pageView.topAnchor.constraint(equalTo: pageControl.bottomAnchor).isActive = true
        pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        pageController.dataSource = self
        pageController.delegate = self
        
        pageControl.numberOfPages = assignments.count
        pageControl.currentPage = start
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false;
        self.navigationController?.hidesBarsOnTap = true
        self.tabBarController?.tabBar.isHidden = true
        self.presentPopupBar(withContentViewController: popupController, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        self.navigationController?.hidesBarsOnTap = false
        self.tabBarController?.tabBar.isHidden = false
        self.dismissPopupBar(animated: true, completion: nil)
    }
    
    func setAssignments(assignments: [Assignment], start: Int) {
        self.pages = [UIViewController?](repeating: nil, count: assignments.count)
        self.assignments = assignments
        self.start = start
        setPage(assignment: self.assignments[start], index: start)
        setPopupURL(viewControllerIndex: start)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func hideNavBar() {
        hideToolBar()
        guard let hidden = self.navigationController?.isNavigationBarHidden else {
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.isNavigationBarHidden = !hidden
        }
    }
    
    @objc func hideToolBar() {
        self.navigationController?.isToolbarHidden = true
        self.view.layoutSubviews()
    }

}

extension PagedAssignmentController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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
    
    func setPage(assignment:Assignment, index: Int) {
        let page = AssignmentPageController()
        page.assignment = assignment
        page.delegate = self
        pages[index] = page
    }
    
    func setPopupURL(viewControllerIndex:Int) {
        let assignment = assignments[viewControllerIndex]
        guard let url = assignment.siteURL else {
            return
        }
        webController.setURL(url: URL(string: url)!)
        webController.shouldLoad = true
        webController.needsToolbar = false
    }
}
