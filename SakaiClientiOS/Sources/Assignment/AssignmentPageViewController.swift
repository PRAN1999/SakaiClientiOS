//
//  AssignmentPageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/17/18.
//

import UIKit

/// Display a full page Assignment view
class AssignmentPageViewController: UIViewController {

    private let assignment: Assignment
    private var pageView: PageView<AssignmentPageView> = PageView(frame: .zero)
    
    weak var textViewDelegate: UITextViewDelegate?
    weak var scrollViewDelegate: UIScrollViewDelegate?

    init(assignment: Assignment) {
        self.assignment = assignment
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = pageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        pageView.scrollView.configure(assignment: assignment)
        pageView.scrollView.delegate = scrollViewDelegate
        pageView.scrollView.instructionView.delegate = textViewDelegate
    }
}
