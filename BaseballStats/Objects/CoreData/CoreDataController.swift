//
//  CoreDataController.swift
//  BaseballStats
//
//  Created by Rakibul Islam on 3/3/18.
//  Copyright © 2018 Rakibul Islam. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController {
    var managedObjectContext: NSManagedObjectContext
    
    
    init(completionBlock: @escaping () -> ()) {
        guard let modelURL = Bundle.main.url(forResource: "BaseballStats", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("Unable to resolve document directory")
            }
            let storeURL = docURL.appendingPathComponent("BaseballStats.sqlite")
            do {
                try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                DispatchQueue.main.sync(execute: completionBlock)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
}
