//
//  Site.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 4/26/18.
//  Copyright © 2018 MAGNUMIUM. All rights reserved.
//

import Foundation

class Site {
    private var id:String?;
    private var title:String?;
    
    init(id:String?, title:String?) {
        self.id = id
        self.title = title
    }
    
    func printSite() {
        print("Site id: \(id!)")
        print("Site title \(title!)")
        print("\n")
    }
}
