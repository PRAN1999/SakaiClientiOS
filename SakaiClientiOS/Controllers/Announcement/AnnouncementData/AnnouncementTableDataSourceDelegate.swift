//
//  AnnouncementTableSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/15/18.
//

import ReusableSource

class AnnouncementTableDataSourceDelegate: ReusableTableDataSourceDelegate<AnnouncementDataProvider, AnnouncementCell>, NetworkSource {
    
    typealias Fetcher = AnnouncementDataFetcher
    
    var siteId: String? {
        get {
            return fetcher.siteId
        } set {
            fetcher.siteId = newValue
        }
    }
    
    var fetcher: AnnouncementDataFetcher
    var controller: UIViewController?
    
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
        
        if indexPath.row == provider.lastAssignmentIndex() && fetcher.moreLoads {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let announcement = provider.item(at: indexPath) else {
            return
        }
        
        let announcementPage = AnnouncementPageController()
        announcementPage.setAnnouncement(announcement)
        
        controller?.navigationController?.pushViewController(announcementPage, animated: true)
    }
    
    override func resetValues() {
        fetcher.resetOffset()
        provider.resetValues()
    }
}
