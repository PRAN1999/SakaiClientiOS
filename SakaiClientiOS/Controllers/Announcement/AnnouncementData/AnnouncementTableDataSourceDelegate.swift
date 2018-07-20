//
//  AnnouncementTableSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/15/18.
//

import ReusableSource

class AnnouncementTableDataSourceDelegate: FeedTableDataSourceDelegate<Announcement, AnnouncementDataProvider, AnnouncementCell, AnnouncementDataFetcher> {
    
    var controller: UIViewController?
    
    var siteId: String? {
        get {
            return fetcher.siteId
        }
        set {
            fetcher.siteId = newValue
        }
    }
    
    init(tableView: UITableView) {
        super.init(provider: AnnouncementDataProvider(), fetcher: AnnouncementDataFetcher(), tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let announcement = provider.item(at: indexPath) else {
            return
        }
        
        let announcementPage = AnnouncementPageController()
        announcementPage.setAnnouncement(announcement)
        
        controller?.navigationController?.pushViewController(announcementPage, animated: true)
    }
}
