//
//  CompaniesController+CreateCompany.swift
//  CoreDataTrain
//
//  Created by joe on 2022/11/29.
//

import UIKit

extension CompaniesController: CreateCompanyControllerDelegate {
    
    func didEditCompany(company: Company) {
        // update my tableview somehow
        let row = companies.firstIndex(of: company)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
}
