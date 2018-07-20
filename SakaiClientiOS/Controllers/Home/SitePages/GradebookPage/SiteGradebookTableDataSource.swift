//
//  SiteGradebookTableDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/18/18.
//

import ReusableSource

class SiteGradebookTableDataSource: ReusableTableDataSource<SingleSectionDataProvider<GradeItem>, GradebookCell>, NetworkSource {
    var fetcher: SiteGradebookDataFetcher
    
    typealias Fetcher = SiteGradebookDataFetcher
    
    init(tableView: UITableView, siteId: String) {
        fetcher = SiteGradebookDataFetcher(siteId: siteId)
        super.init(provider: SingleSectionDataProvider<GradeItem>(), tableView: tableView)
    }
}
