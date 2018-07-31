//
//  ResourceTreeDataSourceDelegate.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/29/18.
//

import RATreeView
import ReusableSource

class ResourceTreeDataSourceDelegate: NSObject, RATreeViewDataSource, RATreeViewDelegate, NetworkSource {
    typealias Fetcher = ResourceDataFetcher
    
    let treeView: RATreeView
    let fetcher: ResourceDataFetcher
    
    var controller: UIViewController?
    
    var resources: [ResourceNode] = []
    
    init(treeView: RATreeView, siteId: String) {
        self.treeView  = treeView
        self.fetcher   = ResourceDataFetcher(siteId: siteId)
        super.init()
        setupTreeView()
    }
    
    func setupTreeView() {
        treeView.delegate = self
        treeView.dataSource = self
        treeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        treeView.register(ResourceCell.self, forCellReuseIdentifier: ResourceCell.reuseIdentifier)
    }
    
    func treeView(_ treeView: RATreeView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? ResourceNode {
            return (item.children != nil) ? item.children!.count : 0
        } else {
            return resources.count
        }
    }
    
    func treeView(_ treeView: RATreeView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? ResourceNode {
            return item.children![index]
        } else {
            return resources[index] as ResourceNode
        }
    }
    
    func treeView(_ treeView: RATreeView, cellForItem item: Any?) -> UITableViewCell {
        guard let cell = treeView.dequeueReusableCell(withIdentifier: ResourceCell.reuseIdentifier) as? ResourceCell else {
            return UITableViewCell()
        }
        
        guard let item = item as? ResourceNode else {
            return UITableViewCell()
        }
        
        let isExpanded = treeView.isCell(forItemExpanded: item)
        
        cell.configure(item.resourceItem, at: treeView.levelForCell(forItem: item), isExpanded: isExpanded)
        
        return cell
    }
    
    // MARK: Treeview Delegate
    
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
            let webController = WebController()
            guard let urlString = resource.resourceItem.url else {
                return
            }
            guard let url = URL(string: urlString) else {
                return
            }
            webController.setURL(url: url)
            controller?.navigationController?.pushViewController(webController, animated: true)
            treeView.deselectRow(forItem: item, animated: false)
        }
    }
    
    func loadDataSource(completion: @escaping () -> Void) {
        resources = []
        treeView.reloadData()
        fetcher.loadData { (res) in
            guard let res = res else {
                return
            }
            self.resources = res
            self.treeView.reloadData()
            completion()
        }
    }
}
