//
//  SiteGradebookTableDataSource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/18/18.
//

import ReusableSource

class GradebookPageTableDataSource: ReusableTableDataSource<SingleSectionDataProvider<GradeItem>, GradebookCell>, NetworkSource {
    var fetcher: GradebookPageDataFetcher
    
    typealias Fetcher = GradebookPageDataFetcher
    
    init(tableView: UITableView, siteId: String) {
        fetcher = GradebookPageDataFetcher(siteId: siteId)
        super.init(provider: SingleSectionDataProvider<GradeItem>(), tableView: tableView)
    }
}
