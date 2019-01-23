//
//  AssignmentPagesViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/17/18.
//

import UIKit
import WebKit
import LNPopupController
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

    private let webController = WebViewController(allowsOptions: false)
    /// A Rich Text editor in order to allow inline submission for Assignments
    private let editorController = RichTextEditorViewController()
    private lazy var containerController
        = SegmentedContainerViewController(segments: [("Web", webController), ("Editor", editorController)])

    // Even when the current Assignment changes, the popup controller
    // instance will be the same but the popup URL will change.
    private lazy var popupController = NavigationController(rootViewController: containerController)

    // The popup bar instance to hide/show Assignment submission option
    private let submitPopupBarController = SubmitPopupBarViewController()

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

        // Configure the LNPopupController instance with the starting index
        configurePopup(viewControllerIndex: start)

        webController.dismissAction = { [weak self] in
            self?.tabBarController?.closePopup(animated: true, completion: nil)
        }
        webController.onWebViewLoad = { [weak self] in
            // Following JavaScript modifies in-browser editor in order to
            // make it easier to work with for native RichTextEditorViewController
            // and scrolls to bring submission form into view in the webView
            self?.webView?.evaluateJavaScript("""
                    CKEDITOR.instances['Assignment.view_submission_text'].destroy();
                    var p = $('#addSubmissionForm');
                    if (p == undefined) {
                        p = document.body;
                    }
                    var offset = p.offset();
                    $('body').scrollTop(offset.top);
                    CKEDITOR.replace('Assignment.view_submission_text', {
                        allowedContent : true,
                        toolbar: [
                                ['Source', '-', 'Bold', 'Italic', 'Underline', '-', 'Link',
                                 'Unlink', '-', 'NumberedList','BulletedList', 'Blockquote']
                        ],
                    });
                """,
                completionHandler: { data, err in
                    DispatchQueue.main.async {
                        self?.editorController.loadHTML()
                    }
            })
        }

        editorController.dismissAction = { [weak self] in
            self?.tabBarController?.closePopup(animated: true, completion: nil)
        }

        editorController.delegate = self
        editorController.needsTitleField = false

        // Popup bar will be presented on outermost container (tabBarController)
        tabBarController?.popupInteractionStyle = .default
        tabBarController?.popupBar.backgroundStyle = .regular
        tabBarController?.popupContentView.popupCloseButtonStyle = .none
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: false)

        // re-enable the pop recognizer for all other view controllers on
        // the navigation stack
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        guard let tabBarController = tabBarController as? TabsController else {
            return
        }

        let isNavigationPushing = navigationController?.viewControllers.last != self

        if isMovingFromParentViewController || isNavigationPushing {
            tabBarController.dismissPopupBar(animated: true, completion: nil)
            return
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // disable the pop recognizer so it doesn't interfere with the paging
        // gestures
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false;

        guard let tabBarController = tabBarController as? TabsController else {
            return
        }

        if tabBarController.popupPresentationState == .hidden ||
           tabBarController.popupPresentationState == .closed {

            containerController.selectTab(at: 0)

            tabBarController.presentPopupBar(withContentViewController: popupController,
                                             animated: true,
                                             completion: nil)

            // When popping back to PagesController, LNPopupController occasionally
            // encounters a bug where it is entirely removed from the view
            // hierarchy and causes a black space to appear in its place.
            // Adding the views back to the tabBarController manually fixes
            // the bug.
            tabBarController.view.addSubview(tabBarController.popupBar)
            tabBarController.view.addSubview(tabBarController.popupContentView)
            tabBarController.popupContentView.popupCloseButtonStyle = .none
        }
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
                self?.configurePopup(viewControllerIndex: index)
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

    private func configurePopup(viewControllerIndex: Int) {
        let assignment = assignments[viewControllerIndex]
        guard let url = URL(string: assignment.siteURL) else {
            return
        }
        webController.title = assignment.title
        webController.setURL(url: url)
        webController.setNeedsLoad(to: true)

        let instructions = PageView.getInstructionsString(attributedText: assignment.attributedInstructions)
        editorController.attributedContext = instructions
        editorController.html = ""

        containerController.selectTab(at: 0)
        if assignment.status == .closed || !assignment.allowsInlineSubmission {
            containerController.disableTab(at: 1)
        } else {
            containerController.enableTab(at: 1)
        }
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

extension AssignmentPagesViewController: RichTextEditorViewControllerDelegate {
    var webView: WKWebView? {
        return webController.webView
    }

    func editorController(_ editorController: RichTextEditorViewController,
                          shouldSaveBody html: String?,
                          didSucceed: @escaping (Bool) -> Void) {
        guard let html = html else {
            didSucceed(false)
            return
        }
        webView?.evaluateJavaScript(
            """
                CKEDITOR.instances['Assignment.view_submission_text'].setData(`
                    \(html)
                `);
            """,
            completionHandler: { _, err in
                if let err = err {
                    print(err)
                    didSucceed(false)
                } else {
                    didSucceed(true)
                }
        })
    }

    func editorController(_ editorController: RichTextEditorViewController,
                          loadTextWithResult result: @escaping (String?) -> Void) {
        webView?.evaluateJavaScript(
            """
                var data = CKEDITOR.instances['Assignment.view_submission_text'].getData();
                CKEDITOR.instances['Assignment.view_submission_text'].resetDirty();
                data;
            """,
            completionHandler: { data, _ in
                result(data as? String)
        })
    }
}