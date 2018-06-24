//
//  DataSourceProtocols.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/2/18.
//

import Foundation
import UIKit

protocol HideableTableDataSource : UITableViewDataSource{
    var numRows:[Int] { get set }
    var numSections:Int { get set }
    
    var isHidden:[Bool] { get set }
    var terms:[Term] { get set }
    
    func loadData(completion: @escaping () -> Void)
    func resetValues()
}
