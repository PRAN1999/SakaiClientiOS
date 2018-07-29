//
//  Resource.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/26/18.
//

import Foundation
import SwiftyJSON

struct ResourceItem {
    
    enum ContentType {
        case collection(Int)
        case resource
    }
    
    let author      :String?
    let title       :String?
    let type        :ContentType
    let url         :String?
    let numChildren :Int
    
    init(_ author       :String?,
         _ title        :String?,
         _ type         :ContentType,
         _ url          :String?,
         _ numChildren  :Int?) {
        self.author      = author
        self.title       = title
        self.type        = type
        self.url         = url
        self.numChildren = (numChildren != nil) ? numChildren! : 0
    }
    
    init(data: JSON) {
        let author      = data["author"].string
        let title       = data["title"].string
        let typeString  = data["type"].string
        let size        = data["size"].int
        let type        = (typeString == "collection" && size != nil) ? ContentType.collection(size!) : ContentType.resource
        let url         = data["url"].string
        let numChildren = data["numChildren"].int
        
        self.init(author, title, type, url, numChildren)
    }
}

class ResourceNode {
    let resourceItem    :ResourceItem
    let children        :[ResourceNode]?
    
    init(_ resourceItem :ResourceItem,
         _ children     :[ResourceNode]?) {
        self.resourceItem   = resourceItem
        self.children       = children
    }
    
    convenience init(data: [ResourceItem]) {
        let root = data[0]
        guard data.count > 1 else {
            self.init(root, nil)
            return
        }
        let subTree = Array(data[1..<data.count])
        let children = ResourceNode.constructTree(data: subTree, numChildren: root.numChildren)
        self.init(root, children)
    }
    
    func totalCount() -> Int {
        guard let children = self.children else {
            return 0
        }
        var count = children.count
        for child in children {
            count += child.totalCount()
        }
        return count
    }
    
    static func constructTree(data: [ResourceItem], numChildren: Int) -> [ResourceNode]? {
        guard data.count > 0 else {
            return nil
        }
        
        var tree = [ResourceNode]()
        
        var index = 0
        for _ in 0..<numChildren {
            
            let nodeItem = data[index]
            var node: ResourceNode?
            
            switch(nodeItem.type) {
                
            case .collection(let size):
                guard size > 0 else {
                    break
                }
                let childrenItems = Array(data[index+1...index+size])
                let children = constructTree(data: childrenItems, numChildren: nodeItem.numChildren)
                node = ResourceNode(nodeItem, children)
                index += size
                break
                
            case .resource:
                node = ResourceNode(nodeItem, nil)
                break
                
            }
            index += 1
            if node != nil {
                tree.append(node!)
            }
        }
        return tree
    }
}
