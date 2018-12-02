//
//  AssignmentPageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/17/18.
//

import UIKit

/// Display a full page Assignment view
class AssignmentPageController: UIViewController {

    var assignment: Assignment

    var pageView: PageView<AssignmentPageView>!
    weak var delegate: UITextViewDelegate?

    init(assignment: Assignment) {
        self.assignment = assignment
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.pageView = PageView(frame: .zero)
        self.view = pageView
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        pageView.backgroundColor = UIColor.white

        pageView.scrollView.configure(assignment: assignment)
        pageView.scrollView.instructionView.delegate = delegate
        pageView.scrollView.attachmentsView.delegate = delegate
    }

}
