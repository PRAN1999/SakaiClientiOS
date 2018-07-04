//
//  CollapsibleSectionController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/2/18.
//

import UIKit

class CollapsibleSectionController: BaseTableViewController, UIGestureRecognizerDelegate {
    
    let TABLE_HEADER_HEIGHT:CGFloat = 50.0
    
    var hideableDataSource: HideableTableDataSource!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Must initialize Controller with dataSource")
    }
    
    override init?(coder aDecoder: NSCoder, dataSource: BaseTableDataSource) {
        fatalError("Must use hideableDataSource")
    }
    
    init?(coder aDecoder: NSCoder, dataSource:HideableTableDataSource) {
        super.init(coder: aDecoder, dataSource: dataSource)
        self.hideableDataSource = dataSource
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UITableViewHeaderFooterView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TermHeader.reuseIdentifier) as? TermHeader else {
            fatalError("Not a Table Header View")
        }
        view.tag = section
        view.setImage(isHidden: hideableDataSource.isHidden[section])
        view.setTitle(title: hideableDataSource.terms[section].getTitle())
        view.tapRecognizer.addTarget(self, action: #selector(handleTap))
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TABLE_HEADER_HEIGHT
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let section = (sender.view?.tag)!
        
        hideableDataSource.isHidden[section] = !hideableDataSource.isHidden[section]
        
        self.tableView.reloadSections([section], with: UITableViewRowAnimation.automatic)
    }
}
