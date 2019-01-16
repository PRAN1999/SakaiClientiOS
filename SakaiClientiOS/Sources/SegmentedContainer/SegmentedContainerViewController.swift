//
//  CustomSubmitContainerViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/14/19.
//

import UIKit

class SegmentedContainerViewController: UIViewController {

    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.removeAllSegments()
        control.frame = CGRect(x: 0, y: 0, width: 170, height: 30)
        return control
    }()

    private let controllers: [UIViewController]
    private var selectedIndex: Int

    init(segments: [(String?, UIViewController)], withSelectedIndex index: Int = 0) {
        var controllers: [UIViewController] = []
        for (index, (title, controller)) in segments.enumerated() {
            segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
            controllers.append(controller)
        }
        self.controllers = controllers
        self.selectedIndex = index
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = segmentedControl
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(sender:)), for: .valueChanged)

        guard controllers.count > 0 else {
            return
        }
        var startIndex = 0
        if selectedIndex >= 0 && selectedIndex < controllers.count {
            startIndex = selectedIndex
        }

        let startViewController = controllers[startIndex]
        segmentedControl.selectedSegmentIndex = startIndex
        add(asChildViewController: startViewController)
    }

    func disableTab(at index: Int) {
        guard index >= 0 && index < controllers.count else {
            return
        }
        segmentedControl.setEnabled(false, forSegmentAt: index)
    }

    func enableTab(at index: Int) {
        guard index >= 0 && index < controllers.count else {
            return
        }
        segmentedControl.setEnabled(true, forSegmentAt: index)
    }

    @objc private func selectionDidChange(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        updateView(forSelectionAt: index)
    }

    private func updateView(forSelectionAt index: Int) {
        guard index >= 0 && index < controllers.count else {
            return
        }

        let oldViewController = controllers[selectedIndex]
        let newViewController = controllers[index]

        remove(asChildViewController: oldViewController)
        add(asChildViewController: newViewController)

        selectedIndex = index
    }

    private func add(asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)

        // Add Child View as Subview
        view.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)

        navigationItem.leftBarButtonItems = viewController.navigationItem.leftBarButtonItems
        navigationItem.rightBarButtonItems = viewController.navigationItem.rightBarButtonItems

        setToolbarItems(viewController.toolbarItems, animated: true)
    }

    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
}
