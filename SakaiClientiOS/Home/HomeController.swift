//
//  HomeController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/23/18.

import Foundation
import UIKit

class HomeController: UITableViewController, UIGestureRecognizerDelegate {
    
    var sites:[[Site]] = [[Site]]()
    var terms:[Term] = [Term]()
    
    var numRows:[Int] = [Int]()
    var numSections = 0
    var isHidden:[Bool] = [Bool]()
    
    var indicator: LoadingIndicator!
    
    override func viewDidLoad() {
        self.title = "Classes"
        self.tableView.register(SiteTableViewCell.self, forCellReuseIdentifier: SiteTableViewCell.reuseIdentifier)
        self.tableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: TableHeaderView.reuseIdentifier)
        
        indicator = LoadingIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100), view: self.tableView as UIView)
        
        if AppGlobals.TO_RELOAD {
            print("loading data")
            AppGlobals.TO_RELOAD = false
            self.loadData()
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadData))
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
        
        if self.isHidden[section] {
            return 0
        }
        return self.numRows[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SiteTableViewCell.reuseIdentifier, for: indexPath) as? SiteTableViewCell else {
            fatalError("Not a Site Table View Cell")
        }
        
        let site:Site = self.sites[indexPath.section][indexPath.row]
            
        cell.titleLabel.text = site.getTitle()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UITableViewHeaderFooterView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.reuseIdentifier) as? TableHeaderView else {
            fatalError("Not a Table Header View")
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapRecognizer.delegate = self
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapRecognizer)
        view.tag = section
        
        if isHidden[section] {
            view.setImageHidden()
        } else {
            view.setImageShow()
        }
        
        view.label.text = "\(getSectionTitle(section: section))"

        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
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
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let section = (sender.view?.tag)!
        
        isHidden[section] = !isHidden[section]
        
        self.tableView.reloadSections([section], with: UITableViewRowAnimation.automatic)
    }
    
    @objc func loadData() {
        self.numRows = []
        self.terms = []
        self.sites = []
        self.isHidden = []
        self.numSections = 0
        
        self.tableView.reloadData()
        
        self.indicator.startAnimating()
        
        RequestManager.shared.getSites(completion: { siteList in
            
            DispatchQueue.main.async {
                guard let list = siteList else {
                    RequestManager.shared.logout()
                    return
                }
                
                if list.count == 0 {
                    RequestManager.shared.logout()
                }
                
                self.numSections = list.count
                
                for index in 0..<list.count {
                    self.numRows.append(list[index].count)
                    self.terms.append(list[index][0].getTerm())
                    self.sites.append(list[index])
                    self.isHidden.append(true)
                }
                
                self.isHidden[0] = false
                
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
