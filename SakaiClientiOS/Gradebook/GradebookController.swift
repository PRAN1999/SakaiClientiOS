//
//  GradebookController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit

class GradebookController: UITableViewController {
    
    var gradeItems:[[GradeItem]] = [[GradeItem]]()
    
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
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.numRows[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func loadData() {
        print("Loading all grades")
    }
    
    func loadData(for siteId:String) {
        RequestManager.shared.getSiteGrades(siteId: siteId) { res in
            print("Loading Site grades")
        }
    }
}
