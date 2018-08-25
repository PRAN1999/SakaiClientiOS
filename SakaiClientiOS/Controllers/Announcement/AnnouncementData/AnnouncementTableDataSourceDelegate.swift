//
//  AnnouncementTableSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/15/18.
//

import ReusableSource

class AnnouncementTableDataSourceDelegate: ReusableTableDataSourceDelegate<AnnouncementDataProvider, AnnouncementCell>, NetworkSource {
    
    typealias Fetcher = AnnouncementDataFetcher
    
    static let filterOptions = [("One Week", 7), ("One Month", 30), ("Six Months", 180), ("One Year", 365), ("Two Years", 730), ("Four Years", 1460)]
    
    var fetcher: AnnouncementDataFetcher
    
    convenience init(tableView: UITableView) {
        self.init(provider: AnnouncementDataProvider(), tableView: tableView)
    }
    
    override init(provider: AnnouncementDataProvider, tableView: UITableView) {
        fetcher = AnnouncementDataFetcher()
        super.init(provider: provider, tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = super.tableView(tableView, cellForRowAt: indexPath) as? AnnouncementCell else {
            return UITableViewCell()
        }
        
        if indexPath.row == provider.lastIndex() && fetcher.moreLoads {
            let frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(70))
            let spinner = LoadingIndicator(frame: frame)
            spinner.activityIndicatorViewStyle = .gray
            spinner.startAnimating()
            spinner.hidesWhenStopped = true
            
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
            fetcher.loadData(completion: { (announcements) in
                DispatchQueue.main.async {
                    spinner.stopAnimating()
                    guard let items = announcements else {
                        return
                    }
                    self.loadItems(payload: items)
                    self.reloadData()
                }
            })
        }
        
        return cell
    }
    
    override func resetValues() {
        fetcher.resetOffset()
        provider.resetValues()
    }
}

extension AnnouncementTableDataSourceDelegate {
    var siteId: String? {
        get {
            return fetcher.siteId
        } set {
            fetcher.siteId = newValue
        }
    }
    
    var daysBack: Int {
        get {
            return fetcher.daysBack
        } set {
            fetcher.daysBack = newValue
        }
    }
}
