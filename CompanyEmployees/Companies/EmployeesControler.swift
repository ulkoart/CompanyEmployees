//
//  EmployeesControler.swift
//  CompanyEmployees
//
//  Created by user on 03.08.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import UIKit

class EmployeesControler: UITableViewController {
    
    var company: Company?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .darkBlue
        
        setupPlusButtonNavBar(selector: #selector(handleAdd))
        

    }
    
    @objc func handleAdd() -> Void {
        let createEmployeeController = CreateEmployeeController()
        let navControler = CustomNavigationController(rootViewController: createEmployeeController)
        navControler.modalPresentationStyle = .fullScreen
        
        present(navControler, animated: true, completion: nil)

    }

}
