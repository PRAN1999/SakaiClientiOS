//
//  HomeController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/23/18.

import Foundation
import UIKit

class HomeController: UITableViewController {
    
    var sites:[[Site]] = [[Site]]()
    var terms:[Term] = [Term]()
    
    var numRows:[Int] = [Int]()
    var numSections = 0
    
    var indicator: LoadingIndicator!
    
    override func viewDidLoad() {
        title = "Home"
        tableView.register(SiteTableViewCell.self, forCellReuseIdentifier: "siteTableViewCell")
        tableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: "tableHeaderView")
        
        indicator = LoadingIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100), view: self.tableView)
        
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return numSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.numRows[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "siteTableViewCell", for: indexPath) as? SiteTableViewCell else {
            fatalError("Not a Site Table View Cell")
        }
        let site:Site = self.sites[indexPath.section][indexPath.row]
            
        cell.titleLabel.text = site.getTitle()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UITableViewHeaderFooterView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "tableHeaderView") as? TableHeaderView else {
            fatalError("Not a Table Header View")
        }

        view.label.text = "\(getSectionTitle(section: section))"

        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*
            Programmatic navigation WITHOUT segues
            Data passing is easier to manage programmatically
        */
        let storyboard:UIStoryboard = self.storyboard!
        let classController:ClassController = storyboard.instantiateViewController(withIdentifier: "classController") as! ClassController
        let site:Site = self.sites[indexPath.section][indexPath.row]
        classController.title = site.getTitle()
        classController.setPages(pages: site.getPages())
        self.navigationController?.pushViewController(classController, animated: true)
    }
    
    func loadData() {
        numRows = []
        terms = []
        sites = []
        numSections = 0
        
        self.tableView.reloadData()
        
        indicator.startAnimating()
        
        RequestManager.getSites(completion: { siteList in
            
            DispatchQueue.main.async {
                guard let list = siteList else {
                    return
                }
                
                self.numSections = list.count
                
                for index in 0..<list.count {
                    self.numRows.append(list[index].count)
                    self.terms.append(list[index][0].getTerm())
                    self.sites.append(list[index])
                }
                
                self.tableView.reloadData()
                
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
        })
    }
    
    func getSectionTitle(section:Int) -> String {
        guard let string = terms[section].getTermString(), let year = terms[section].getYear() else {
            return "General"
        }
        return "\(string) \(year)"
    }
}
