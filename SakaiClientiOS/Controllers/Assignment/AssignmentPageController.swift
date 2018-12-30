//
//  AssignmentPageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/17/18.
//

import UIKit

/// Display a full page Assignment view
class AssignmentPageController: UIViewController {

    private let assignment: Assignment
    private var pageView: PageView<AssignmentPageView> = PageView(frame: .zero)
    
    weak var delegate: UITextViewDelegate?

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
        pageView.scrollView.instructionView.delegate = delegate
        pageView.scrollView.attachmentsView.delegate = delegate
    }
}
