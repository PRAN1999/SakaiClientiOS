//
//  AssignmentPageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/17/18.
//

import UIKit

class AssignmentPageController: UIViewController {

    var pageView: AssignmentPageView!
    var assignment: Assignment?
    
    override func loadView() {
        self.pageView = AssignmentPageView(frame: .zero)
        self.view = pageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageView.backgroundColor = UIColor.white
        pageView.titleLabel.setText(text: assignment?.getTitle())
        pageView.scrollView.gradeLabel.setKeyVal(key: "Current Grade:", val: assignment?.getCurrentGrade())
        pageView.scrollView.pointsLabel.setKeyVal(key: "Max Points:", val: assignment?.getMaxPoints())
        pageView.scrollView.submissionLabel.setKeyVal(key: "Allows Resubmission:", val: assignment?.getResubmission())
        pageView.scrollView.statusLabel.setKeyVal(key: "Status:", val: assignment?.getStatus())
        pageView.scrollView.dueLabel.setKeyVal(key: "Due:", val: assignment?.getDueTimeString())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
