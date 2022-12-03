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
    
    func createEmployee(employeeName: String, company: Company) -> (Employee?, Error?) {
        let context = persistentContainer.viewContext
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        employee.company = company
        
        // let's check company is setup correctly
//        let company = Company(context: context)
//        company.employees
//
//        employee.company
        
        employee.setValue(employeeName, forKey: "name")
        
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
//        employeeInformation.setValue("456", forKey: "taxId")  // to be crashed whenever the key has changed
        employeeInformation.taxId = "456"
        employee.employeeinformation = employeeInformation
        
        do {
            try context.save()
            return (employee, nil)
        } catch let err {
            print("Failed to create employee:", err)
            return (nil, err)
        }
    }
}
