//
//  AnnouncementDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/30/18.
//

import UIKit

class AnnouncementDataSource: NSObject, BaseTableDataSource {
    var numRows: [Int] = [Int]()
    
    var numSections: Int = 1
    
    var hasLoaded: Bool = false
    
    var isLoading: Bool = false
    
    func loadData(completion: @escaping () -> Void) {
        
    }
    
    func resetValues() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRows[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
}
