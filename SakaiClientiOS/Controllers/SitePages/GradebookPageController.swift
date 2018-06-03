//
//  GradebookPageControllerTableViewController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 5/22/18.
//

import UIKit

class GradebookPageController: UITableViewController {

    var siteId:String!
    var indicator:LoadingIndicator!
    
    var numRows:Int!
    var gradeItems:[GradeItem] = [GradeItem]()
    
    init(siteId:String, style:UITableViewStyle) {
        super.init(style: style)
        self.siteId = siteId
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(GradebookCell.self, forCellReuseIdentifier: GradebookCell.reuseIdentifier)
        
        self.indicator = LoadingIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100), view: self.tableView)
        
        self.loadData(for: siteId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: GradebookCell.reuseIdentifier, for: indexPath) as? GradebookCell else {
            fatalError("Not a gradebook cell")
        }
        
        let gradeItem = self.gradeItems[indexPath.row]
        
        var grade:String
        if gradeItem.getGrade() != nil {
            grade = "\(gradeItem.getGrade()!)"
        } else {
            grade = ""
        }
        
        cell.titleLabel.text = gradeItem.getTitle()
        cell.gradeLabel.text = "\(grade) / \(gradeItem.getPoints())"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gradeItems.count
    }
    
    func loadData(for siteId:String) {
        self.indicator.startAnimating()
        RequestManager.shared.getSiteGrades(siteId: siteId) { res in
            
            DispatchQueue.main.async {
                print("Loading Site grades")
                
                guard let grades = res else {
                    return
                }
                
                self.numRows = grades.count
                
                self.gradeItems = grades
                
                self.tableView.reloadData()
                
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
        }
    }

}
