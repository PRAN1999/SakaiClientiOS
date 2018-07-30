//
//  ResourceNode.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/29/18.
//

import Foundation

/// A Node item to represent a Tree structure for Resources
class ResourceNode {
    
    let resourceItem    :ResourceItem
    let children        :[ResourceNode]?
    
    /// Initialize a ResourceNode with a data ResourceItem and children Nodes
    ///
    /// - Parameters:
    ///   - resourceItem: The data item specific to the ResourceNode
    ///   - children: The children of the ResourceNode
    init(_ resourceItem :ResourceItem,
         _ children     :[ResourceNode]?) {
        self.resourceItem   = resourceItem
        self.children       = children
    }
    
    /// Initialize a ResourceNode with the first element in the data as the root of the ResourceNode tree
    ///
    /// - Parameter data: A flattened data tree with the root of the tree as the first element
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
    
    /// Recursively construct an array of child ResourceNode's given the flattened subtree and a given number of children
    ///
    /// - Parameters:
    ///   - data: The flattened subtree representing all the child subtrees
    ///   - numChildren: The number of child trees contained within the data array
    /// - Returns: An array of child ResourceNode's
    static func constructTree(data: [ResourceItem], numChildren: Int) -> [ResourceNode]? {
        guard data.count > 0 else {
            return nil
        }
        
        var tree = [ResourceNode]()
        
        var index = 0
        for _ in 0..<numChildren {
            
            guard index < data.count else {
                continue
            }
            
            let nodeItem = data[index]
            var node: ResourceNode?
            
            switch(nodeItem.type) {
                
            case .collection(let size):
                guard size > 0 else {
                    break
                }
                // Create an array slice of all the children of the collection based on the size of the collection
                let childrenItems = Array(data[index+1...index+size])
                // Recursively construct the child subtrees based on the number of direct children in the collection and the children data slice
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
