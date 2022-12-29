//
//  ViewController.swift
//  CoreDataTrain
//
//  Created by joe on 11/18/2022.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
  
    var companies = [Company]()   // empty array
    
    @objc private func doWork() {
        print("Trying to do work...")
        
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            (0...5).forEach { (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)
            }
            
            do {
                try backgroundContext.save()
                
                DispatchQueue.main.async {
                    self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData()
                }
            } catch let err {
                print("Failed to save:", err)
            }
        }
        
        // CGD - Grand Central Dispatch
//        DispatchQueue.global(qos: .background).async {
            // creating some Compamy objects on a background thread
//            let context = CoreDataManager.shared.persistentContainer.viewContext
//            let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
            
//            (0...20000).forEach { (value) in
//                print(value)
//                let company = Company(context: context)
//                company.name = String(value)
//            }
//
//            do {
//                try context.save()
//            } catch let err {
//                print("Failed to save:", err)
//            }
//        }
    }
    
    // let's do some tricky updates with core data
    @objc private func doUpdates() {
        print("Trying to update companies on a background context")
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
//            let request: NSFetchRequest<Company> = Company.fetchRequest()
            let request = NSFetchRequest<Company>(entityName: "Company")
            do {
                let companies = try backgroundContext.fetch(request)
                companies.forEach { (company) in
                    print(company.name ?? "")
                    company.name = "C: \(company.name ?? "")"
                }
                
                do {
                    try backgroundContext.save()
                    // update the UI after a save
                    DispatchQueue.main.async {
                        // reset() will forget all of the objects you've fetch before
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        // you don't want to refetch everything if you just simply update one or two companies
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        // is there a way to just merge the changes that you made onto the main view context?
                        self.tableView.reloadData()
                    }
                } catch let saveErr {
                    print("Failed to save on background:", saveErr)
                }
            } catch let err {
                print("Failed to fetch companies on background:", err)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companies = CoreDataManager.shared.fetchCompanies()
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Do Updates", style: .plain, target: self, action: #selector(doUpdates))
        ]
        
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    @objc private func handleReset() {
        print("Attempting to delete all core data objects")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            // upon deletion from core data succeeded
            var indexPathsToRemove = [IndexPath]()
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
        } catch let delErr {
            print("Failed to delete objects from Core Data:", delErr)
        }
    }
    
    @objc func handleAddCompany() {
        print("Adding company..")
        
        let createCompanyController = CreateCompanyController()
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        createCompanyController.delegate = self
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
}

