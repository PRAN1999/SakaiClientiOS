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
    var delegate:PagesController!
    
    override func loadView() {
        self.pageView = AssignmentPageView(frame: .zero)
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
        
        pageView.titleLabel.titleLabel.text = assignment?.title
        
        pageView.scrollView.classLabel.setKeyVal(key: "Class:", val: assignment?.siteTitle)
        pageView.scrollView.gradeLabel.setKeyVal(key: "Current Grade:", val: assignment?.currentGrade)
        pageView.scrollView.pointsLabel.setKeyVal(key: "Max Points:", val: assignment?.maxPoints)
        pageView.scrollView.submissionLabel.setKeyVal(key: "Allows Resubmission:", val: assignment?.resubmissionAllowed)
        pageView.scrollView.statusLabel.setKeyVal(key: "Status:", val: assignment?.status)
        pageView.scrollView.dueLabel.setKeyVal(key: "Due:", val: assignment?.dueTimeString)
        pageView.scrollView.setInstructions(attributedText: assignment?.attributedInstructions)
        pageView.scrollView.setAttachments(resources: assignment?.attachments)
        
        pageView.scrollView.instructionView.delegate = delegate
        pageView.scrollView.attachmentsView.delegate = delegate
    }

}
