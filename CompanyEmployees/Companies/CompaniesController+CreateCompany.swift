//
//  CompaniesController+CreateCompany.swift
//  CompanyEmployees
//
//  Created by user on 02.08.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import UIKit

extension CompaniesController: CreateCompanyControllerDelegatage {
    
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEdidtCompany(company: Company) {
        let row = companies.firstIndex(of: company)
        let reloadIndexpath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexpath], with: .middle)
    }
}
