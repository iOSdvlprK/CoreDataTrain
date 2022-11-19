//
//  ViewController.swift
//  CoreDataTrain
//
//  Created by joe on 11/18/2022.
//

import UIKit

class CompaniesController: UITableViewController {
    
    let companies = [
        Company(name: "Apple", founded: Date()),
        Company(name: "Google", founded: Date()),
        Company(name: "Google", founded: Date())
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        
        tableView.backgroundColor = .darkBlue
//        tableView.separatorStyle = .none
        tableView.separatorColor = .white
//        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let newNavBarAppearance = customNavBarAppearance()
        navigationController?.navigationBar.scrollEdgeAppearance = newNavBarAppearance
        navigationController?.navigationBar.compactAppearance = newNavBarAppearance
        navigationController?.navigationBar.standardAppearance = newNavBarAppearance
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    @objc func handleAddCompany() {
        print("Adding company..")
        
        let createCompanyController = CreateCompanyController()
//        createCompanyController.view.backgroundColor = .green
        let navController = UINavigationController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = .tealColor
        let company = companies[indexPath.row]
        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    @available(iOS 13.0, *)
    func customNavBarAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        
        // Apply a light red background
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .lightRed
        
        // Apply white colored normal and large titles
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        return appearance
    }
    
}
