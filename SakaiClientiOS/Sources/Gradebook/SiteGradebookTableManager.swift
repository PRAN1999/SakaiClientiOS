//
//  SiteGradebookTableDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/18/18.
//

import ReusableSource

class SiteGradebookTableManager: ReusableTableManager<SingleSectionDataProvider<GradeItem>, GradebookCell>,
                                 NetworkSource {
    typealias Fetcher = SiteGradebookDataFetcher
    
    let fetcher: SiteGradebookDataFetcher
    weak var delegate: NetworkSourceDelegate?
    
    convenience init(tableView: UITableView, siteId: String) {
        let fetcher = SiteGradebookDataFetcher(siteId: siteId,
                                               networkService: RequestManager.shared)
        self.init(provider: SingleSectionDataProvider<GradeItem>(),
                  fetcher: fetcher,
                  tableView: tableView)
    }

    init(provider: Provider, fetcher: Fetcher, tableView: UITableView) {
        self.fetcher = fetcher
        super.init(provider: provider, tableView: tableView)
    }
    
    override func setup() {
        super.setup()
        emptyView.backgroundColor = Palette.main.primaryBackgroundColor
        emptyView.textColor = Palette.main.secondaryTextColor
        tableView.allowsSelection = false
    }

    override func isEmpty() -> Bool {
        return provider.items.count == 0
    }
}
