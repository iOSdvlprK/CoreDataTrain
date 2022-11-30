//
//  EmployeesController.swift
//  CoreDataTrain
//
//  Created by joe on 2022/11/30.
//

import UIKit

class EmployeesController: UITableViewController {
    
    var company: Company?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .darkBlue
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
    }
    
    @objc private func handleAdd() {
        print("Trying to add an employee..")
        let createEmployeeController = CreateEmployeeController()
        let navController = UINavigationController(rootViewController: createEmployeeController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
}
