//
//  HideableTableDataSourceDelegate.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/22/18.
//

import UIKit
import ReusableSource

class HideableTableManager<Provider: HideableDataProvider, Cell: UITableViewCell & ConfigurableCell> : ReusableTableManager<Provider, Cell>, UIGestureRecognizerDelegate where Provider.T == Cell.T {
    
    let tableHeaderHeight: CGFloat = 50.0
    
    override func setup() {
        super.setup()
        tableView.register(TermHeader.self, forHeaderFooterViewReuseIdentifier: TermHeader.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if provider.isEmpty(section: indexPath.section) {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
            cell.textLabel?.text = "Looks like there's nothing here"
            return cell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provider.numberOfItemsForHideableSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TermHeader.reuseIdentifier) as? TermHeader else {
            fatalError("Not a Table Header View")
        }
        view.tag = section
        view.setImage(isHidden: provider.isHidden[section])
        view.titleLabel.text = provider.terms[section].getTitle()
        view.tapRecognizer.delegate = self
        view.tapRecognizer.addTarget(self, action: #selector(handleTap))
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableHeaderHeight
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let section = (sender.view?.tag)!
        
        provider.isHidden[section] = !provider.isHidden[section]
        
        reloadData(for: section)
    }
}
