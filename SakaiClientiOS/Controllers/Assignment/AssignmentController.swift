//
//  AssignmentController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//

import UIKit

class AssignmentController: CollapsibleSectionController {
    
    let TABLE_CELL_HEIGHT:CGFloat = 40.0
    
    var siteDataSource: SiteDataSource = SiteDataSource()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, dataSource: siteDataSource)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(SiteTableViewCell.self, forCellReuseIdentifier: SiteTableViewCell.reuseIdentifier)
        self.tableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: TableHeaderView.reuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.TABLE_CELL_HEIGHT
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionController = AssignmentCollectionController(collectionViewLayout: UICollectionViewFlowLayout())
        self.navigationController?.pushViewController(collectionController, animated: true)
    }

}
