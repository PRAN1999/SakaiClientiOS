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
    private var description:String?
    
    init(id:String?, title:String?, description:String?) {
        self.id = id
        self.title = title
        if let validDescription = description, isValidDescription(description: validDescription) {
            self.description = validDescription
        } else {
            self.description = "Description not available"
        }
    }
    
    func printSite() {
        print("Site id: \(id!)")
        print("Site title \(title!)")
    }
    
    func isValidDescription(description:String) -> Bool {
        return description.count < 300
    }
    
    func getId() -> String? {
        return self.id
    }
    
    func getTitle() -> String? {
        return self.title
    }
    
    func getDescription() -> String? {
        return self.description
    }
}
