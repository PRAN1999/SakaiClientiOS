//
//  HideableTableDataSourceDelegate.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/22/18.
//

import UIKit
import ReusableSource

class HideableTableDataSourceDelegate<Provider: HideableDataProvider, Cell: UITableViewCell & ConfigurableCell> : ReusableTableDataSourceDelegate<Provider, Cell>, UIGestureRecognizerDelegate where Provider.T == Cell.T {
    
    let TABLE_HEADER_HEIGHT:CGFloat = 50.0
    
    override func setup() {
        super.setup()
        tableView.register(TermHeader.self, forHeaderFooterViewReuseIdentifier: TermHeader.reuseIdentifier)
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
        return TABLE_HEADER_HEIGHT
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let section = (sender.view?.tag)!
        
        provider.isHidden[section] = !provider.isHidden[section]
        
        reloadData(for: section)
    }
}
