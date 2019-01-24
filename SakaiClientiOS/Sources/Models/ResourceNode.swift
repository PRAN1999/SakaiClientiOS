//
//  ResourceNode.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 7/29/18.
//

import Foundation

class ResourceNode {

    let resourceItem: ResourceItem
    let children: [ResourceNode]

    init(_ resourceItem: ResourceItem,
         _ children: [ResourceNode]) {
        self.resourceItem   = resourceItem
        self.children       = children
    }

    /// Initialize a ResourceNode with the first element in the data as the
    /// root of the ResourceNode tree
    ///
    /// - Parameter data: A flattened data tree with the root of the tree
    ///                   as the first element
    convenience init(data: [ResourceItem]) {
        let root = data[0]
        guard data.count > 1 else {
            self.init(root, [])
            return
        }
        let subTree = Array(data[1..<data.count])
        let (_, children) = ResourceNode.constructTree(data: subTree,
                                                  numChildren: root.numChildren,
                                                  onLevel: 0)
        self.init(root, children)
    }

    /// Recursively construct an array of child ResourceNode's given the
    /// flattened subtree and a given number of children
    ///
    /// - Parameters:
    ///   - data: The flattened subtree representing all the child subtrees
    ///   - numChildren: The number of child trees contained within the
    ///                  data array
    ///
    /// - Returns: An array of child ResourceNode's
    static func constructTree(data: [ResourceItem], numChildren: Int, onLevel: Int) -> (Int, [ResourceNode]) {
        guard data.count > 0 else {
            return (0, [])
        }
        var tree = [ResourceNode]()
        var index = 0
        for _ in 0..<numChildren {
            guard index < data.count else {
                break
            }
            let nodeItem = data[index]
            let node: ResourceNode
            guard nodeItem.level == onLevel else {
                return (index, tree)
            }
            
            switch nodeItem.type {
            case .collection(let size):
                guard index + 1 < data.count, size > 0 else {
                    node = ResourceNode(nodeItem, [])
                    break
                }

                let start = index + 1
                let end = min(index + size, data.count - 1)
                
                // Create an array slice of all the children of the
                // collection based on the size of the collection
                let childrenItems = Array(data[start...end])

                // Recursively construct the child subtrees based on the
                // number of direct children in the collection and the
                // children data slice
                let (subtreeSize, children) = constructTree(data: childrenItems,
                                             numChildren: nodeItem.numChildren,
                                             onLevel: nodeItem.level + 1)
                node = ResourceNode(nodeItem, children)
                index += subtreeSize
                break
            case .resource:
                node = ResourceNode(nodeItem, [])
                break
            }
            index += 1
            tree.append(node)
        }
        return (data.count, tree)
    }
}
