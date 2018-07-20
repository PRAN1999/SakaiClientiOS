//
//  FeedTableDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/19/18.
//

import ReusableSource

class FeedTableDataSourceDelegate<T, Provider: SingleSectionDataProvider<T>, Cell: ConfigurableCell & UITableViewCell, Fetcher: FeedDataFetcher>: ReusableTableDataSourceDelegate<Provider, Cell>, NetworkSource where T == Cell.T, Fetcher.T == [T] {
    
    var fetcher: Fetcher
    
    init(provider: Provider, fetcher: Fetcher, tableView: UITableView) {
        self.fetcher = fetcher
        super.init(provider: provider, tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = super.tableView(tableView, cellForRowAt: indexPath) as? Cell else {
            return UITableViewCell()
        }
        
        if indexPath.row == provider.items.count - 1 && fetcher.moreLoads {
            let frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(70))
            let spinner = LoadingIndicator(frame: frame)
            spinner.activityIndicatorViewStyle = .gray
            spinner.startAnimating()
            spinner.hidesWhenStopped = true
            
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
            fetcher.loadData { (announcements) in
                spinner.stopAnimating()
                guard let items = announcements else {
                    return
                }
                self.loadItems(payload: items)
                self.reloadData()
            }
        }
        
        return cell
    }
    
    override func resetValues() {
        fetcher.resetOffset()
        provider.resetValues()
    }
}
