//
//  HideableDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/2/18.
//

import Foundation
import UIKit

protocol HideableDataSource : UITableViewDataSource {
    
    var isHidden:[Bool] { get set }
    var terms:[Term] { get set }
    
    var numRows:[Int] { get set }
    var numSections:Int { get set }
    
    func loadData(completion: @escaping () -> Void)
    
    func resetValues()
}
