//
//  GradebookController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit

class GradebookController: UITableViewController {
    
    var gradeItems:[[GradeItem]] = [[GradeItem]]()
    var terms:[Term] = [Term]()
    
    var numRows:[Int] = [Int]()
    var numSections:Int = 0
    
    var isSitePage: Bool = false 
    var siteId: String?
    
    var indicator:LoadingIndicator!
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    convenience init(siteId: String, style: UITableViewStyle) {
        self.init(style: style)
        self.isSitePage = true
        self.siteId = siteId
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(GradebookCell.self, forCellReuseIdentifier: "gradebookCell")
        self.tableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: "tableHeaderView")
        
        self.indicator = LoadingIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100), view: self.tableView)
        
        if self.isSitePage {
            self.loadData(for: self.siteId!)
        } else {
            self.loadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.numSections
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "gradebookCell", for: indexPath) as? GradebookCell else {
            fatalError("Not a gradebook cell")
        }
        
        let gradeItem = self.gradeItems[indexPath.section][indexPath.row]
        
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
        return self.numRows[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if isSitePage {
            return nil
        }
        
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "tableHeaderView") as? TableHeaderView else {
            fatalError("Not a Table Header View")
        }
        
        view.label.text = "\(getSectionTitle(section: section))"
        
        return view
    }
    
    func loadData() {
        self.indicator.startAnimating()
        RequestManager.shared.getAllGrades { res in
            DispatchQueue.main.async {
                print("Loading all grades")
                
                guard let list = res else {
                    return
                }
                
                self.numSections = list.count
                
                for index in 0..<list.count {
                    self.numRows.append(list[index].count)
                    self.terms.append(list[index][0].getTerm())
                    self.gradeItems.append(list[index])
                }
                
                self.tableView.reloadData()
                
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
        }
    }
    
    func loadData(for siteId:String) {
        self.indicator.startAnimating()
        RequestManager.shared.getSiteGrades(siteId: siteId) { res in
            
            DispatchQueue.main.async {
                print("Loading Site grades")
                
                guard let grades = res else {
                    return
                }
                
                self.numRows.append(grades[0].count)
                self.numSections = 1
                
                self.gradeItems.append(grades[0])
                
                self.tableView.reloadData()
                
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
        }
    }
    
    func getSectionTitle(section:Int) -> String {
        guard let string = terms[section].getTermString(), let year = terms[section].getYear() else {
            return "General"
        }
        return "\(string) \(year)"
    }

}
