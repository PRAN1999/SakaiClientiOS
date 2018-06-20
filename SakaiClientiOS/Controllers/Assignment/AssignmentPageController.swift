//
//  AssignmentPageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/17/18.
//

import UIKit

class AssignmentPageController: UIViewController {

    var pageView: AssignmentPageView!
    var assignmentTitle:String?
    
    override func loadView() {
        pageView = AssignmentPageView(frame: .zero)
        view = pageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageView.backgroundColor = UIColor.white
        pageView.titleLabel.setText(text: assignmentTitle)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
