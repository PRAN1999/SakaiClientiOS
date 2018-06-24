//
//  File.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/2/18.
//

import Foundation
import UIKit

class SiteDataSource: BaseTableDataSourceImplementation {
    
    var sites:[[Site]] = [[Site]]()
    
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
        
        RequestManager.shared.getSites(completion: { siteList in
            
            DispatchQueue.main.async {
                guard let list = siteList else {
                    return
                }
                
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
}
