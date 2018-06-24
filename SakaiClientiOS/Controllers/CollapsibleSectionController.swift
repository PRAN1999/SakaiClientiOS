//
//  CollapsibleSectionController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/2/18.
//

import UIKit

class CollapsibleSectionController: UITableViewController, UIGestureRecognizerDelegate {
    
    let TABLE_HEADER_HEIGHT:CGFloat = 50.0
    
    var dataSource: HideableTableDataSource!
    var indicator: LoadingIndicator!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Must initialize Controller with dataSource")
    }
    
    init?(coder aDecoder: NSCoder, dataSource:HideableTableDataSource) {
        super.init(coder: aDecoder)
        self.dataSource = dataSource
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dataSource
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadDataSource))
        
        indicator = LoadingIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100), view: self.tableView)
        loadDataSource()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UITableViewHeaderFooterView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TermHeader.reuseIdentifier) as? TermHeader else {
            fatalError("Not a Table Header View")
        }
        
        view.tag = section
        view.setImage(isHidden: dataSource.isHidden[section])
        view.setTitle(title: dataSource.terms[section].getTitle())
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
        
        dataSource.isHidden[section] = !dataSource.isHidden[section]
        
        self.tableView.reloadSections([section], with: UITableViewRowAnimation.automatic)
    }

    @objc func loadDataSource() {
        dataSource.resetValues()
        self.tableView.reloadData()
    
        indicator.startAnimating()
        
        dataSource.loadData(completion: {
            self.tableView.reloadData()
            
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
        })
    }
}
