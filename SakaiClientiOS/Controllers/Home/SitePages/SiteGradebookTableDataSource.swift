//
//  SiteGradebookTableDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/18/18.
//

import ReusableSource

class SiteGradebookTableDataSource: ReusableTableDataSource<SingleSectionDataProvider<GradeItem>, GradebookCell>, NetworkSource {
    weak var delegate: NetworkSourceDelegate?

    typealias Fetcher = SiteGradebookDataFetcher
    
    var fetcher: SiteGradebookDataFetcher
    
    init(tableView: UITableView, siteId: String) {
        fetcher = SiteGradebookDataFetcher(siteId: siteId)
        super.init(provider: SingleSectionDataProvider<GradeItem>(), tableView: tableView)
    }
    
    override func setup() {
        super.setup()
        tableView.allowsSelection = false
    }
}