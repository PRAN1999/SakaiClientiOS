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
    var delegate:PagedAssignmentController!
    
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
        
        pageView.titleLabel.setText(text: assignment?.getTitle())
        
        pageView.scrollView.classLabel.setKeyVal(key: "Class:", val: RequestManager.shared.siteTitleMap[assignment!.getSiteId()])
        pageView.scrollView.gradeLabel.setKeyVal(key: "Current Grade:", val: assignment?.getCurrentGrade())
        pageView.scrollView.pointsLabel.setKeyVal(key: "Max Points:", val: assignment?.getMaxPoints())
        pageView.scrollView.submissionLabel.setKeyVal(key: "Allows Resubmission:", val: assignment?.getResubmission())
        pageView.scrollView.statusLabel.setKeyVal(key: "Status:", val: assignment?.getStatus())
        pageView.scrollView.dueLabel.setKeyVal(key: "Due:", val: assignment?.getDueTimeString())
        pageView.scrollView.setInstructions(attributedText: assignment?.getAttributedInstructions())
        pageView.scrollView.setAttachments(resources: assignment?.getAttachments())
        
        pageView.scrollView.instructionView.delegate = delegate
        pageView.scrollView.attachmentsView.delegate = delegate
        
        pageView.scrollView.instructionTapRecognizer.addTarget(delegate, action: #selector(delegate.hideNavBar))
        pageView.scrollView.attachmentsTapRecognizer.addTarget(delegate, action: #selector(delegate.hideNavBar))
    }

}
