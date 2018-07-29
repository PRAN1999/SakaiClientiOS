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
        
        cell.configure(item.resourceItem, at: treeView.levelForCell(forItem: item))
        return cell
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
