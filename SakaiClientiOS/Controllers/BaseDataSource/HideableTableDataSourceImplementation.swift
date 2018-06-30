//
//  BaseDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/3/18.
//

import Foundation
import UIKit

class HideableTableDataSourceImplementation: NSObject, HideableTableDataSource {
    
    var isHidden: [Bool] = [Bool]()
    
    var terms:[Term] = [Term]()
    
    var numRows:[Int] = [Int]()
    var numSections = 0
    
    var hasLoaded:Bool = false
    var isLoading:Bool = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isHidden[section] {
            return 0
        }
        return numRows[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Must override cellForRowAt for every data source implementation. Should not be instantiating BaseDataSourceImplementation")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numSections
    }
    
    func resetValues() {
        numRows = []
        terms = []
        numSections = 0
        
        isHidden = []
    }
    
    func loadData(completion: @escaping () -> Void) {
        fatalError("Must override loadData for every data source implementation. Should not be instantiating BaseDataSourceImplementation")
    }
}
