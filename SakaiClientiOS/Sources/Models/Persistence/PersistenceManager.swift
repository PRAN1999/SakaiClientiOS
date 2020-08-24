//
//  PersistentManager.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 10/7/18.
//

import UIKit
import CoreData

class PersistenceManager {

    static let shared = PersistenceManager()

    var delegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }

    var managedContext: NSManagedObjectContext? {
        return delegate?.persistentContainer.viewContext
    }

    private init() {}
    
}
