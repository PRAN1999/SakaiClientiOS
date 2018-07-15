//
//  File.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/2/18.
//

import Foundation
import UIKit

@available(*, deprecated: 1.0) class SiteDataSource: BaseHideableTableDataSourceImplementation {
    
    var sites:[[Site]] = [[Site]]()
    lazy var filteredSites:[[Site]] = sites
    var controller:UIViewController?
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SiteCell.reuseIdentifier, for: indexPath) as? SiteCell else {
            fatalError("Not a Site Table View Cell")
        }
        
        let site:Site = filteredSites[indexPath.section][indexPath.row]
        
        cell.titleLabel.text = site.title
        
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
                    completion()
                    return
                }
                
                self.enableTabs()
                
                if list.count == 0 {
                    completion()
                    return
                }
                
                super.numSections = list.count
                
                for index in 0..<list.count {
                    super.numRows.append(list[index].count)
                    super.terms.append(list[index][0].term)
                    self.sites.append(list[index])
                    super.isHidden.append(true)
                }
                
                self.filteredSites = self.sites
                super.isHidden[0] = false
                
                completion()
            }
        })
    }
}

@available(*, deprecated: 1.0) extension SiteDataSource {
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
