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
    
    func fetchCompanies() -> [Company] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch let fetchErr {
            print("Failed to fetch companies: ", fetchErr)
            return []
        }
    }
    
    func createEmployee(employeeName: String) -> Error? {
        let context = persistentContainer.viewContext
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)
        employee.setValue(employeeName, forKey: "name")
        do {
            try context.save()
            return nil
        } catch let err {
            print("Failed to create employee:", err)
            return err
        }
    }
}
