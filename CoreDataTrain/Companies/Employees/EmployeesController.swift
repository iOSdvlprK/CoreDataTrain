//
//  EmployeesController.swift
//  CoreDataTrain
//
//  Created by joe on 2022/11/30.
//

import UIKit
import CoreData

// create a UILabel subclass for custom text drawing
class IndentedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = rect.inset(by: insets)
        super.drawText(in: customRect)
    }
}

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }
    
    var company: Company?
    var employees = [Employee]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
        let label = IndentedLabel()
        if section == 0 {
            label.text = "Short names"
        } else if section == 1 {
            label.text = "Long names"
        } else {
            label.text = "Really long names"
        }
        label.backgroundColor = UIColor.lightBlue
        label.textColor = UIColor.darkBlue
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    var shortNameEmployees = [Employee]()
    var longNameEmployees = [Employee]()
    var reallyLongNameEmployees = [Employee]()
    
    var allEmployees = [[Employee]]()
    
    private func fetchEmployees() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
//        self.employees = companyEmployees
        shortNameEmployees = companyEmployees.filter({ employee -> Bool in
            if let count = employee.name?.count {
                return count < 6
            }
            return false
        })
        longNameEmployees = companyEmployees.filter({ employee -> Bool in
            if let count = employee.name?.count {
                return count > 6 && count < 9
            }
            return false
        })
        reallyLongNameEmployees = companyEmployees.filter({ employee in
            if let count = employee.name?.count {
                return count > 9
            }
            return false
        })
        allEmployees = [
            shortNameEmployees,
            longNameEmployees,
            reallyLongNameEmployees
        ]
        print(shortNameEmployees.count, longNameEmployees.count, reallyLongNameEmployees.count)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return shortNameEmployees.count
//        }
//        return longNameEmployees.count
        return allEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
//        let employee = indexPath.section == 0 ? shortNameEmployees[indexPath.row] : longNameEmployees[indexPath.row]
        let employee = allEmployees[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = employee.name
        
//        if let taxId = employee.employeeinformation?.taxId {
//            cell.textLabel?.text = "\(employee.name ?? "")   \(taxId)"
//        }
        if let birthday = employee.employeeinformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            cell.textLabel?.text = "\(employee.name ?? "")   \(dateFormatter.string(from: birthday))"
        }
        
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = .boldSystemFont(ofSize: 15)
        return cell
    }
    
    let cellId = "cellllllllllllId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEmployees()
        tableView.backgroundColor = .darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    @objc private func handleAdd() {
        print("Trying to add an employee..")
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = CustomNavigationController(rootViewController: createEmployeeController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
}
