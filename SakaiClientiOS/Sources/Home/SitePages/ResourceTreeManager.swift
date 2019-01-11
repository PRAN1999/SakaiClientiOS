//
//  ResourceTreeManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/29/18.
//

import RATreeView
import ReusableSource

/// Manages RATreeView by loading and presenting fetched Resource Data.
/// Every cell in the TreeView is configured with a ResourceItem that
/// represents a folder or an individual resource file in the Tree
class ResourceTreeManager: NSObject, RATreeViewDataSource, RATreeViewDelegate, NetworkSource {
    typealias Fetcher = ResourceDataFetcher

    weak var delegate: NetworkSourceDelegate?

    private var resources: [ResourceNode] = []

    private let treeView: RATreeView

    /// The callback for selection of an individual Resource link
    var didSelectResource = Delegated<URL, Void>()
    let fetcher: ResourceDataFetcher
    
    convenience init(treeView: RATreeView, siteId: String) {
        let fetcher = ResourceDataFetcher(siteId: siteId, networkService: RequestManager.shared)
        self.init(fetcher: fetcher, treeView: treeView)
    }

    init(fetcher: Fetcher, treeView: RATreeView) {
        self.treeView = treeView
        self.fetcher = fetcher
        super.init()
        setupTreeView()
    }
    
    private func setupTreeView() {
        treeView.delegate = self
        treeView.dataSource = self
        treeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        treeView.register(ResourceCell.self, forCellReuseIdentifier: ResourceCell.reuseIdentifier)
        treeView.separatorColor = Palette.main.tableViewSeparatorColor
        treeView.scrollView.indicatorStyle = Palette.main.scrollViewIndicatorStyle
    }

    // MARK: TreeView Data Source
    
    func treeView(_ treeView: RATreeView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? ResourceNode {
            return item.children.count
        } else {
            return resources.count
        }
    }
    
    func treeView(_ treeView: RATreeView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? ResourceNode {
            return item.children[index]
        } else {
            return resources[index] as ResourceNode
        }
    }
    
    func treeView(_ treeView: RATreeView, cellForItem item: Any?) -> UITableViewCell {
        guard
            let cell = treeView
                .dequeueReusableCell(withIdentifier: ResourceCell.reuseIdentifier) as? ResourceCell
            else {
            return UITableViewCell()
        }
        
        guard let item = item as? ResourceNode else {
            return UITableViewCell()
        }
        let isExpanded = treeView.isCell(forItemExpanded: item)
        cell.configure(item.resourceItem,
                       at: treeView.levelForCell(forItem: item),
                       isExpanded: isExpanded)
        return cell
    }
    
    // MARK: TreeView Delegate
    
    func treeView(_ treeView: RATreeView, canEditRowForItem item: Any) -> Bool {
        return false
    }
    
    func treeView(_ treeView: RATreeView, didSelectRowForItem item: Any) {
        guard let resource = item as? ResourceNode else {
            return
        }
        guard let cell = treeView.cell(forItem: item) as? ResourceCell else {
            return
        }
        let level = treeView.level(for: cell)
        let isExpanded = !treeView.isCellExpanded(cell)
        
        switch(resource.resourceItem.type) {
        case .collection:
            cell.configure(resource.resourceItem, at: level, isExpanded: isExpanded)
            return
        case .resource:
            treeView.deselectRow(forItem: item, animated: false)
            guard let urlString = resource.resourceItem.url else {
                return
            }
            guard let url = URL(string: urlString) else {
                return
            }
            didSelectResource.call(url)
        }
    }

    func prepareDataSourceForLoad() {
        resources = []
        treeView.reloadData()
    }

    func populateDataSource(with payload: [ResourceNode]) {
        resources = payload
        treeView.reloadData()
    }
}
