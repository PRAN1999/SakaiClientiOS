//
//  BaseDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/3/18.
//

import Foundation
import UIKit

class BaseDataSourceImplementation: NSObject, HideableDataSource {
    var isHidden: [Bool] = [Bool]()
    
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
        fatalError("Must override cellForRowAt for every data source implementation. Should not be instantiating BaseDataSource")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numSections
    }
    
    func resetValues() {
        self.numRows = []
        self.terms = []
        self.numSections = 0
        
        self.isHidden = []
    }
    
    func loadData(completion: @escaping () -> Void) {
        fatalError("Must override loadData for every data source implementation. Should not be instantiating BaseDataSource")
    }
}

