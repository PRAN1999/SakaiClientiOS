//
//  AssignmentController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit

class AssignmentController: CollapsibleSectionController {
    var siteAssignmentDataSource: SiteAssignmentsDataSource!
    var dateSortedAssignmentDataSource: DateSortedAssignmentDataSource!
    
    var dateSorted:Bool = true
    var selectedIndex = 0
    var hasLoaded:[Bool] = [false, false]
    
    var segments:UISegmentedControl!
    var button1: UIBarButtonItem!
    var button2: UIBarButtonItem!
    var flexButton: UIBarButtonItem!
    
    required init?(coder aDecoder: NSCoder) {
        dateSortedAssignmentDataSource = DateSortedAssignmentDataSource()
        siteAssignmentDataSource  = SiteAssignmentsDataSource()
        super.init(coder: aDecoder, dataSource: dateSortedAssignmentDataSource)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hasLoaded[0] = true
        
        super.tableView.allowsSelection = false
        super.tableView.register(AssignmentTableCell.self, forCellReuseIdentifier: AssignmentTableCell.reuseIdentifier)
        super.tableView.register(TermHeader.self, forHeaderFooterViewReuseIdentifier: TermHeader.reuseIdentifier)
        
        siteAssignmentDataSource.collectionViewDelegate = self
        siteAssignmentDataSource.textViewDelegate = self
        
        dateSortedAssignmentDataSource.collectionViewDelegate = self
        dateSortedAssignmentDataSource.textViewDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setToolbar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func resort() {
        if dateSorted {
            dateSorted = false
            selectedIndex = 1
            super.dataSource = siteAssignmentDataSource
            super.tableView.dataSource = siteAssignmentDataSource
        } else {
            dateSorted = true
            selectedIndex = 0
            super.dataSource = dateSortedAssignmentDataSource
            super.tableView.dataSource = dateSortedAssignmentDataSource
        }
        if !super.dataSource.hasLoaded && !super.dataSource.isLoading {
            super.loadDataSource()
        } else {
            super.indicator.stopAnimating()
            super.tableView.reloadData()
        }
    }

    func setToolbar() {
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.barTintColor = UIColor.black
        
        segments = UISegmentedControl.init(items: ["Date", "Class"])
        segments.frame = (self.navigationController?.toolbar.frame)!
        
        segments.translatesAutoresizingMaskIntoConstraints = false
        segments.selectedSegmentIndex = selectedIndex
        segments.setWidth(self.view.frame.size.width / 4, forSegmentAt: 0)
        segments.setWidth(self.view.frame.size.width / 4, forSegmentAt: 1)
        segments.addTarget(self, action: #selector(resort), for: UIControlEvents.valueChanged)
        segments.tintColor = AppGlobals.SAKAI_RED
        
        button1 = UIBarButtonItem(customView: segments);
        button2 = UIBarButtonItem(customView: segments);
        flexButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        flexButton.width = self.view.frame.size.width / 4 - 15
        
        let arr:[UIBarButtonItem] = [flexButton, button1, button2, flexButton]
        
        self.navigationController?.toolbar.setItems(arr, animated: true)
    }
}

extension AssignmentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "AssignmentView", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "pagedController") as! PagedAssignmentController
        let dataSource = collectionView.dataSource as! AssignmentDataSource
        controller.setAssignments(assignments: dataSource.assignments, start: indexPath.row)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension AssignmentController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size:CGSize!
        size = CGSize(width: collectionView.bounds.width / 1.9, height: collectionView.bounds.height)
        return size
    }
}
