//
//  CollapsibleSectionController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 6/2/18.
//

import UIKit

class CollapsibleSectionController: UITableViewController {
    
    var isHidden:[Bool] = [Bool]()
    var dataSource:HideableDataSource!
    
    var indicator: LoadingIndicator!
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init?(coder aDecoder: NSCoder, dataSource:HideableDataSource) {
        super.init(coder: aDecoder)
        self.dataSource = dataSource
    }
    
    convenience init(dataSource:HideableDataSource, style: UITableViewStyle) {
        self.init(style: style)
        self.dataSource = dataSource
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dataSource
        self.indicator = LoadingIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100), view: self.tableView)
        self.loadDataSource()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadDataSource))
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UITableViewHeaderFooterView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.reuseIdentifier) as? TableHeaderView else {
            fatalError("Not a Table Header View")
        }
        
        view.tag = section
        view.setImage(isHidden: dataSource.isHidden[section])
        view.setTitle(title: dataSource.terms[section].getTitle())
        view.tapRecognizer.addTarget(self, action: #selector(handleTap))
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let section = (sender.view?.tag)!
        
        dataSource.isHidden[section] = !dataSource.isHidden[section]
        
        self.tableView.reloadSections([section], with: UITableViewRowAnimation.automatic)
    }

    @objc func loadDataSource() {
        self.dataSource.resetValues()
        self.tableView.reloadData()
    
        self.indicator.startAnimating()
        
        self.dataSource.loadData(completion: {
            self.tableView.reloadData()
            
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
        })
    }
}
