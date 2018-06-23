//
//  PagedAssignmentController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/17/18.
//

import UIKit

class PagedAssignmentController: UIPageViewController {

    var pages: [UIViewController?] = [UIViewController]()
    var assignments: [Assignment] = [Assignment]()
    var start:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.setup()
    }
    
    func setAssignments(assignments: [Assignment], start: Int) {
        pages = [UIViewController?](repeating: nil, count: assignments.count)
        self.assignments = assignments
        self.start = start
        self.setPage(assignment: self.assignments[start], index: start)
    }
    
    func setup() {
        guard let startPage = pages[start] else {
            return
        }
        self.setViewControllers([startPage], direction: .forward, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension PagedAssignmentController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        if self.pages[previousIndex] == nil {
            self.setPage(assignment: self.assignments[previousIndex], index: previousIndex)
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let assignmentsCount = assignments.count
        
        guard nextIndex < assignmentsCount else {
            return nil
        }
        
        if self.pages[nextIndex] == nil {
            self.setPage(assignment: self.assignments[nextIndex], index: nextIndex)
        }
        
        return pages[nextIndex]
    }
    
    func setPage(assignment:Assignment, index: Int) {
        let page = AssignmentPageController()
        page.assignment = assignment
        self.pages[index] = page
    }
}
