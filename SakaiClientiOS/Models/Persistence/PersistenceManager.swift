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

    private init() {}

    func retrieveSites() -> [PersistedSite]? {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }

        guard let userId = RequestManager.shared.userId else {
            RequestManager.shared.logout()
            return nil
        }

        let managedContext = delegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<PersistedUser>()
        let predicate = NSPredicate(format: "userId == %@", userId)
        fetchRequest.predicate = predicate

        var persistedSites: [PersistedSite] = []

        do {
            let data = try managedContext.fetch(fetchRequest)
            if data.count <= 0 {
                return []
            }
            persistedSites = data[0].sites
            
        } catch let error {
            print(error.localizedDescription)
        }

        return persistedSites
    }

    func updateSites(sites: [Site]) {
        
    }

}
