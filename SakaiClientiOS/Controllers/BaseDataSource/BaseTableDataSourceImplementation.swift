//
//  BaseTableDataSourceImplementation.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/5/18.
//

import Foundation
import UIKit

class BaseTableDataSourceImplementation : NSObject, BaseTableDataSource {
    
    var numRows:[Int] = [Int]()
    var numSections:Int = 0
    
    var hasLoaded: Bool = false
    var isLoading: Bool = false
    
    func resetValues() {
        numRows = []
        numSections = 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRows[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Must override cellForRowAt for every data source implementation. Should not be instantiating BaseTableDataSourceImplementation")
    }
    
    func loadData(completion: @escaping () -> Void) {
        fatalError("Must override cellForRowAt for every data source implementation. Should not be instantiating BaseTableDataSourceImplementation")
    }
}
