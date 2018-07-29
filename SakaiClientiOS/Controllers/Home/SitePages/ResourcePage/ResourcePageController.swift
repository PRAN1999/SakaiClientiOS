//
//  ResourcePageController.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/28/18.
//

import UIKit
import RATreeView

class ResourcePageController: UIViewController, RATreeViewDelegate, RATreeViewDataSource, SitePageController {
    
    var treeView: RATreeView!
    var resources: [ResourceNode] = []
    
    var siteId: String?
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTreeView()
        treeView.register(ResourceCell.self, forCellReuseIdentifier: ResourceCell.reuseIdentifier)
        loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTreeView() {
        treeView = RATreeView(frame: view.bounds)
        treeView.delegate = self
        treeView.dataSource = self
        treeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        treeView.treeFooterView = UIView()
        treeView.backgroundColor = .clear
        self.view.addSubview(treeView)
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
    
    func loadData() {
        SakaiService.shared.getSiteResources(for: siteId!) { (res) in
            guard let res = res else {
                return
            }
            self.resources = res
            self.treeView.reloadData()
        }
    }
}
