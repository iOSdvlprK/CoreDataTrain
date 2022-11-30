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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companies = CoreDataManager.shared.fetchCompanies()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
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

