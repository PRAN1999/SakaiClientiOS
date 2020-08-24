//
//  AnnouncementTableManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/15/18.
//

import ReusableSource

/// Manage the TableView that presents Announcement Feed
///
/// Since the Announcements are presented as a feed of information, more
/// Announcements will be requested as the user scrolls down the UITableView
/// giving an endless scroll UI experiences
class AnnouncementTableManager: ReusableTableManager<AnnouncementDataProvider, AnnouncementCell>, NetworkSource {
    typealias Fetcher = AnnouncementDataFetcher

    let fetcher: AnnouncementDataFetcher

    private var isLoading = false
    weak var delegate: NetworkSourceDelegate?
    
    convenience init(tableView: UITableView) {
        self.init(fetcher: AnnouncementDataFetcher(networkService: RequestManager.shared),
                  provider: AnnouncementDataProvider(),
                  tableView: tableView)
    }

    init(fetcher: Fetcher, provider: Provider, tableView: UITableView) {
        self.fetcher = fetcher
        super.init(provider: provider, tableView: tableView)
    }

    override func setup() {
        super.setup()
        tableView.tableFooterView = UIView()
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0

        tableView.backgroundColor = Palette.main.primaryBackgroundColor
        tableView.separatorColor = Palette.main.tableViewSeparatorColor
        tableView.indicatorStyle = Palette.main.scrollViewIndicatorStyle

        emptyView.backgroundColor = Palette.main.primaryBackgroundColor
        emptyView.textColor = Palette.main.secondaryTextColor
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = super.tableView(tableView, cellForRowAt: indexPath) as? AnnouncementCell else {
            return UITableViewCell()
        }

        // Load announcment data 10 cells before the end of the scrollView
        if indexPath.row >= provider.lastIndex() - 10 && fetcher.moreLoads && !isLoading {
            isLoading = true
            loadMoreData()
        }
        
        return cell
    }
    
    override func resetValues() {
        fetcher.resetOffset()
        provider.resetValues()
    }

    /// Retrieve more Announcements from the fetcher and reload the TableView
    private func loadMoreData() {
        let frame = CGRect(x: CGFloat(0),
                           y: CGFloat(0),
                           width: tableView.bounds.width,
                           height: CGFloat(70))
        let spinner = LoadingIndicator(frame: frame)
        spinner.style = .white
        spinner.startAnimating()
        spinner.hidesWhenStopped = true

        // Keep a reference to original footer view and then replace it with
        // activity indicator
        let oldFooter = tableView.tableFooterView
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false

        // It's possible the fetcher will not kick off a network request
        // due to it caching the announcement response. In that case, it will be
        // converting the cached Announcement objects' html to text before
        // calling back. In that case, those operations should not occur on
        // the main thread as they are quite expensive.
        DispatchQueue.global().async { [weak self] in
            self?.fetcher.loadData(completion: { announcements, err in
                // Reload data on the main queue
                DispatchQueue.main.async {
                    spinner.stopAnimating()
                    self?.tableView.tableFooterView = oldFooter
                    self?.isLoading = false
                    guard err == nil else {
                        self?.delegate?.networkSourceFailedToLoadData(self, withError: err!)
                        return
                    }
                    guard let items = announcements else {
                        return
                    }
                    self?.loadItems(payload: items)
                    self?.reloadData()
                }
            })
        }
    }

    override func isEmpty() -> Bool {
        return provider.items.count == 0
    }
}

extension AnnouncementTableManager {
    var siteId: String? {
        get {
            return fetcher.siteId
        } set {
            fetcher.siteId = newValue
        }
    }
}
