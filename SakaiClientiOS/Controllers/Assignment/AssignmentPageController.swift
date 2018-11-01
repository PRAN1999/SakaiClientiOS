//
//  AssignmentPageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/17/18.
//

import UIKit

/// Display a full page Assignment view
class AssignmentPageController: UIViewController {

    var pageView: PageView<AssignmentPageView>!
    var assignment: Assignment?
    var delegate: PagesController!
    
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

        guard let assignment = assignment else {
            return
        }
        
        pageView.scrollView.configure(assignment: assignment)
        
        pageView.scrollView.instructionView.delegate = delegate
        pageView.scrollView.attachmentsView.delegate = delegate
    }

}
