//
//  BaseDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/3/18.
//

import Foundation
import UIKit

class BaseHideableTableDataSourceImplementation: BaseTableDataSourceImplementation, BaseHideableTableDataSource {
    
    var isHidden: [Bool] = [Bool]()
    var terms:[Term] = [Term]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isHidden[section] {
            return 0
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numSections
    }
    
    override func resetValues() {
        terms = []
        isHidden = []
        super.resetValues()
    }
}

