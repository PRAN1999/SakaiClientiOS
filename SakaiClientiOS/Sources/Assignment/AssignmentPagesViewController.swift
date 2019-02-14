//
//  AssignmentPagesViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/17/18.
//

import UIKit
import WebKit
import SafariServices

/// The container view controller allowing pagination between multiple
/// Assignments
class AssignmentPagesViewController: UIViewController {

    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = Palette.main.highlightColor
        pageControl.pageIndicatorTintColor = Palette.main.pageIndicatorTintColor
        return pageControl
    }()
    private let pageControlView = UIView()
    private let pageController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal, options: nil)

    let submitButton: UIButton = {
        let button: UIButton = UIView.defaultAutoLayoutView()
        button.backgroundColor = Palette.main.highlightColor
        button.titleLabel?.textColor = Palette.main.primaryTextColor
        let image = UIImage(named: "submit-button")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: UIControlState.normal)
        button.tintColor = Palette.main.primaryTextColor
        button.alpha = 0.75
        return button
    }()

    /// If the pageController begins to animate, the index it will reach if the
    /// animation completes
    private var pendingIndex: Int?

    /// Managed array of ViewControllers for pagesController. There will
    /// be one for each Assignment injected
    private var pages: [UIViewController?]

    private var bottomConstraint, topConstraint: NSLayoutConstraint?

    weak var delegate: AssignmentPagesViewControllerDelegate?

    private let assignments: [Assignment]
    private let start: Int

    init(assignments: [Assignment], start: Int) {
        self.assignments = assignments
        self.start = start
        pages = [UIViewController?](repeating: nil, count: assignments.count)
        super.init(nibName: nil, bundle: nil)
        setPage(assignment: assignments[start], index: start)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        guard let pageView = pageController.view else {
            return
        }
        view.addSubview(pageView)
        pageView.constrainToEdges(of: view, onSides: [.left, .right])

        let margins = view.layoutMarginsGuide
        // Keep track of bottom and top margins so they can be readjusted,
        // when transitioning away from screen
        topConstraint = pageView.topAnchor.constraint(equalTo: margins.topAnchor)
        bottomConstraint = pageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        topConstraint?.isActive = true; bottomConstraint?.isActive = true

        let buttonSize: CGFloat = 65
        view.addSubview(submitButton)
        submitButton.constrainToMargins(of: view, onSides: [.right])
        submitButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -5.0).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        submitButton.layer.cornerRadius = buttonSize / 2

        submitButton.addTarget(self, action: #selector(presentSubmissionView), for: .touchUpInside)

        guard let startPage = pages[start] else {
            return
        }
        pageController.setViewControllers([startPage],
                                          direction: .forward, animated: false, completion: nil)
        pageController.dataSource = self
        pageController.delegate = self

        pageControl.numberOfPages = assignments.count
        pageControl.currentPage = start

        pageControlView.addSubview(pageControl)
        navigationItem.titleView = pageControlView
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: false)

        // re-enable the pop recognizer for all other view controllers on
        // the navigation stack
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // disable the pop recognizer so it doesn't interfere with the paging
        // gestures
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false;
    }

    @objc private func presentSubmissionView() {
        let webController = WebViewController(allowsOptions: false)
        /// A Rich Text editor in order to allow inline submission for Assignments
        let editorController = RichTextEditorViewController()

        webController.dismissAction = { [weak self] in
            self?.tabBarController?.dismiss(animated: true, completion: nil)
        }
        webController.onWebViewLoad = {
            // Following JavaScript modifies in-browser editor in order to
            // make it easier to work with for native RichTextEditorViewController
            // and scrolls to bring submission form into view in the webView
            webController.webView?.evaluateJavaScript(webController.ckeditorDestroyScript) { data, err in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    webController.webView?.evaluateJavaScript(webController.ckeditorReplaceScript) { data, err in
                        editorController.loadHTML()
                    }
                }
            }
        }

        editorController.dismissAction = webController.dismissAction
        editorController.delegate = webController

        let assignment = assignments[pageControl.currentPage]
        guard let url = URL(string: assignment.siteURL) else {
            return
        }
        webController.title = assignment.title
        webController.setURL(url: url)
        webController.setNeedsLoad(to: true)

        editorController.html = ""

        let containerController = SegmentedContainerViewController(segments:
            [("Web", webController), ("Editor", editorController)]
        )
        containerController.selectTab(at: 0)
        if assignment.status == .closed {
            containerController.disableTab(at: 1)
        }

        let navVC = NavigationController(rootViewController: containerController)

        tabBarController?.present(navVC, animated: true, completion: nil)
    }
}

extension AssignmentPagesViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }

        if pages[previousIndex] == nil {
            setPage(assignment: assignments[previousIndex], index: previousIndex)
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
                                
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }

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
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {

        pendingIndex = pages.index(of: pendingViewControllers.first)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {

        // If the animation completed, the pageControl should update to reflect
        // animation
        if completed, let index = pendingIndex {
            DispatchQueue.main.async { [weak self] in
                self?.pageControl.currentPage = index
                if let target = self {
                    // Used to update collectionView in previous ViewController
                    target.delegate?.pageController(target, didMoveToIndex: index)
                }
            }
        }
    }

    /// Configure an AssignmentPageViewController for an assignment. Called
    /// only once for each Assignment and then the same controller will be
    /// reused as the user pages by being assigned to the corresponding index
    /// location in the pages array
    ///
    /// - Parameters:
    ///   - assignment: the assignment model to inject into the ViewController
    ///   - index: the index of the assignment in the assignments array
    private func setPage(assignment: Assignment, index: Int) {
        let page = AssignmentPageViewController(assignment: assignment)
        page.textViewDelegate = self
        page.scrollViewDelegate = self
        pages[index] = page
    }
}

// MARK: Animatable Extension

extension AssignmentPagesViewController: Animatable {
    var containerView: UIView? {
        return view
    }

    var childView: UIView? {
        return pageController.view
    }

    func dismissingView(sizeAnimator: UIViewPropertyAnimator, fromFrame: CGRect, toFrame: CGRect) {
        childView?.layer.cornerRadius = AssignmentCell.cornerRadius
        childView?.layer.borderWidth = 0.5
        childView?.layer.borderColor = Palette.main.borderColor.cgColor
        childView?.layoutIfNeeded()

        submitButton.removeFromSuperview()
        view.layoutIfNeeded()

        topConstraint?.isActive = false
        bottomConstraint?.isActive = false
        // If left constrained the margins rather than the views actual
        // edges, the collapsing animation would have compressed the actual
        // view between ugly black margins on the top and bottom of the
        // "card" it is transitioning to
        childView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        childView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension AssignmentPagesViewController: NavigationAnimatable {
    func animationControllerForPop(to controller: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if controller is AssignmentsViewController || controller is SiteAssignmentsViewController {
            return CollapseDismissAnimationController(resizingDuration: 0.5)
        }
        return nil
    }

    func animationControllerForPush(to controller: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

extension AssignmentPagesViewController: UITextViewDelegate {
    public func textView(_ textView: UITextView,
                         shouldInteractWith URL: URL,
                         in characterRange: NSRange) -> Bool {
        return defaultTextViewURLInteraction(URL: URL)
    }
}
