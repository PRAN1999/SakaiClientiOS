//
//  File.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/2/18.
//

import Foundation
import UIKit

class SiteDataSource: NSObject, HideableDataSource {
    
    var isHidden: [Bool] = [Bool]()
    
    var sites:[[Site]] = [[Site]]()
    var terms:[Term] = [Term]()
    
    var numRows:[Int] = [Int]()
    var numSections = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isHidden[section] {
            return 0
        }
        return self.numRows[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SiteTableViewCell.reuseIdentifier, for: indexPath) as? SiteTableViewCell else {
            fatalError("Not a Site Table View Cell")
        }
        
        let site:Site = self.sites[indexPath.section][indexPath.row]
        
        cell.titleLabel.text = site.getTitle()
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("numSections: \(numSections)")
        return numSections
    }
    
    func resetValues() {
        self.numRows = []
        self.terms = []
        self.sites = []
        self.numSections = 0
        
        self.isHidden = []
    }
    
    func loadData(completion: @escaping () -> Void) {
        
        print("Loading")
        
        RequestManager.shared.getSites(completion: { siteList in
            
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
            
            completion()
        })
    }
}
