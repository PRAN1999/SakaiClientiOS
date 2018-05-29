//
//  GradebookController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit

class GradebookController: UITableViewController {
    
    var gradeItems:[[[GradeItem]]] = [[[GradeItem]]]()
    var terms:[Term] = [Term]()
    
    var numRows:[Int] = [Int]()
    var numSections:Int = 0
    
    var headerCell:SiteTableViewCell!
    
    var indicator:LoadingIndicator!
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(GradebookCell.self, forCellReuseIdentifier: GradebookCell.reuseIdentifier)
        self.tableView.register(SiteTableViewCell.self, forCellReuseIdentifier: SiteTableViewCell.reuseIdentifier)
        self.tableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: TableHeaderView.reuseIdentifier)
        
        self.indicator = LoadingIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100), view: self.tableView)
        
        self.tableView.delegate = self
        
        self.setupHeaderCell()
        
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.numSections
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subsectionIndex = getSubsectionIndexPath(section: indexPath.section, row: indexPath.row)
        
        if subsectionIndex.row == 0 {
            return getSiteTitleCell(indexPath: indexPath, subsection: subsectionIndex.section)
        } else {
            return getGradebookCell(indexPath: indexPath, subsection: subsectionIndex.section, row: subsectionIndex.row - 1)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numRows[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.reuseIdentifier) as? TableHeaderView else {
            fatalError("Not a Table Header View")
        }
        
        view.label.text = "\(getSectionTitle(section: section))"
        
        return view
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let point = CGPoint(x: 0, y: self.tableView.contentOffset.y + 51)
        guard let topIndex = self.tableView.indexPathForRow(at: point) else {
            return
        }
        
        let subsectionIndex = self.getSubsectionIndexPath(section: topIndex.section, row: topIndex.row)
        let headerRow = self.getHeaderRowForSubsection(section: topIndex.section, indexPath: subsectionIndex)
        let cell = self.tableView.cellForRow(at: IndexPath(row: headerRow, section: topIndex.section))
        
        if(cell != nil && (cell?.frame.maxY)! > self.tableView.contentOffset.y + 50) {
            self.hideHeaderCell()
        } else {
            self.makeHeaderCellVisible(section: topIndex.section, subsection: subsectionIndex.section)
        }
    }
    
    func setupHeaderCell() {
        self.headerCell = SiteTableViewCell()
        self.headerCell.backgroundColor = UIColor.red
        self.tableView.addSubview(headerCell)
        
        self.headerCell.translatesAutoresizingMaskIntoConstraints = false
        
        self.headerCell.accessoryType = UITableViewCellAccessoryType.none
        self.headerCell.isHidden = true
    }
    
    func makeHeaderCellVisible(section:Int, subsection:Int) {
        self.headerCell.isHidden = false
        self.headerCell.frame = CGRect(x: 0, y: self.tableView.contentOffset.y + 50, width: self.tableView.frame.size.width, height: self.headerCell.frame.size.height)
        self.headerCell.titleLabel.text = self.getSubsectionTitle(section: section, subsection: subsection)
        self.tableView.bringSubview(toFront: self.headerCell)
    }
    
    func hideHeaderCell() {
        self.headerCell.isHidden = true
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
                self.gradeItems = list
                
                for i in 0..<self.numSections {
                    self.terms.append(list[i][0][0].getTerm())
                    var numRows:Int = list[i].count
                    
                    for j in 0..<list[i].count {
                        numRows += list[i][j].count
                    }
                    self.numRows.append(numRows)
                }
                
                self.tableView.reloadData()
                
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
        }
    }
    
    func getSubsectionIndexPath(section:Int, row:Int) -> IndexPath {
        let termSection:[[GradeItem]] = self.gradeItems[section]
        
        var startRow:Int = row
        var subsection:Int = 0
        
        while startRow > 0 {
            //print("Section: \(section) Subsection: \(subsection) StartRow: \(startRow)")
            startRow -= (termSection[subsection].count + 1)
            if(startRow >= 0) {
                subsection += 1
            }
        }
        
        let subRow:Int = 0 - startRow
        
        return IndexPath(row: subRow, section: subsection)
    }
    
    func getHeaderRowForSubsection(section:Int, indexPath:IndexPath) -> Int {
        var row:Int = 0
        
        for index in 0..<indexPath.section {
            row += self.gradeItems[section][index].count + 1
        }
        
        return row
    }
    
    func getGradebookCell(indexPath: IndexPath, subsection:Int, row:Int) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "gradebookCell", for: indexPath) as? GradebookCell else {
            fatalError("Not a gradebook cell")
        }
        
        //print("Subsection: \(subsection) Row: \(row)")
        let gradeItem:GradeItem = self.gradeItems[indexPath.section][subsection][row]
        
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
    
    func getSiteTitleCell(indexPath: IndexPath, subsection:Int) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: SiteTableViewCell.reuseIdentifier, for: indexPath) as? SiteTableViewCell else {
            fatalError("Not a site cell")
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.none
        cell.titleLabel.text = getSubsectionTitle(section: indexPath.section, subsection: subsection)
        cell.backgroundColor = UIColor.red
        
        return cell
    }
    
    func getSectionTitle(section:Int) -> String {
        guard let string = terms[section].getTermString(), let year = terms[section].getYear() else {
            return "General"
        }
        return "\(string) \(year)"
    }
    
    func getSubsectionTitle(section:Int, subsection:Int) -> String? {
        let siteId:String = self.gradeItems[section][subsection][0].getSiteId()
        let title:String? = AppGlobals.siteTitleMap[siteId]
        return title
    }

}
