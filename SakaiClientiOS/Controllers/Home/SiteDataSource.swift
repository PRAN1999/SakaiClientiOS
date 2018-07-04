//
//  File.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/2/18.
//

import Foundation
import UIKit

class SiteDataSource: HideableTableDataSourceImplementation {
    
    var sites:[[Site]] = [[Site]]()
    var controller:UIViewController?
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SiteCell.reuseIdentifier, for: indexPath) as? SiteCell else {
            fatalError("Not a Site Table View Cell")
        }
        
        let site:Site = sites[indexPath.section][indexPath.row]
        
        cell.titleLabel.text = site.getTitle()
        
        return cell
    }
    
    override func resetValues() {
        super.resetValues()
        sites = []
    }
    
    override func loadData(completion: @escaping () -> Void) {
        
        disableTabs()
        
        DataHandler.shared.getSites(completion: { siteList in
            
            DispatchQueue.main.async {
                guard let list = siteList else {
                    return
                }
                
                self.enableTabs()
                
                if list.count == 0 {
                    return
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
            }
        })
    }
    
    func disableTabs() {
        let items = controller?.tabBarController?.tabBar.items
        
        if let arr = items {
            for i in 1..<5 {
                arr[i].isEnabled = false
            }
        }
    }
    
    func enableTabs() {
        let items = controller?.tabBarController?.tabBar.items
        
        if let arr = items {
            for i in 1..<5 {
                arr[i].isEnabled = true
            }
        }
    }
}
