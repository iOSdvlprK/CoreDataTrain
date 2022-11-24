//
//  CoreDataManager.swift
//  CoreDataTrain
//
//  Created by joe on 11/20/2022.
//

import CoreData

struct CoreDataManager {
    // will live forever as long as your application is still alive
    // its properties will too
    static let shared = CoreDataManager()
    
    // initialization of our Core Data stack
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataTrain")
        container.loadPersistentStores { storeDescription, err in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
}