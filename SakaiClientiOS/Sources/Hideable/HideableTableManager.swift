//
//  HideableTableManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/22/18.
//

import UIKit
import ReusableSource

/// A ReusableTableManager extension to manage a data source and UI delegate
/// for hideable Term-based sections. Creates toggles on section headers in
/// tableView to hide/show data
class HideableTableManager
    <Provider: HideableDataProvider, Cell: UITableViewCell & ConfigurableCell>
    : ReusableTableManager<Provider, Cell>, UIGestureRecognizerDelegate
    where Provider.T == Cell.T {
    
    let tableHeaderHeight: CGFloat = 50.0
    
    override func setup() {
        super.setup()
        tableView.register(TermHeader.self,
                           forHeaderFooterViewReuseIdentifier: TermHeader.reuseIdentifier)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: String(describing: UITableViewCell.self))
        emptyView.backgroundColor = Palette.main.primaryBackgroundColor
        emptyView.textColor = Palette.main.secondaryTextColor
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if provider.isEmpty(section: indexPath.section) {
            let cell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: UITableViewCell.self),
                    for: indexPath
            )
            cell.textLabel?.text = "Looks like there's nothing here"
            cell.backgroundColor = Palette.main.primaryBackgroundColor
            cell.textLabel?.textColor = Palette.main.secondaryTextColor
            return cell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return provider.numberOfItemsForHideableSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: TermHeader.reuseIdentifier) as? TermHeader else {
                return nil
        }
        
        view.tag = section
        view.setImage(isHidden: provider.isHidden(section: section))
        view.titleLabel.text = provider.getTerm(for: section)?.getTitle()
        view.tapRecognizer.delegate = self
        view.tapRecognizer.addTarget(self, action: #selector(handleTap))
        return view
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat {
        return tableHeaderHeight
    }
    
    /// Show and hide Term sections based on taps
    ///
    /// - Parameter sender: the tap recognizer in a TermHeader
    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag else {
            return
        }

        provider.toggleHidden(for: section, to: !provider.isHidden(section: section))
        reloadData(for: section)
    }
}
