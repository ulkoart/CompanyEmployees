//
//  ViewController.swift
//  CompanyEmployees
//
//  Created by user on 13.07.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companies = CoreDataManager.shared.fetchCompanies()
        
        setupPlusButtonNavBar(selector: #selector(handleAddCompany))
        
        view.backgroundColor = .white
        navigationItem.title = "Companies"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
        tableView.backgroundColor = .darkBlue
        // tableView.separatorStyle = .none
        tableView.separatorColor = .white
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) // or .zero
    }
    
    @objc func handleReset() -> Void {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
            
            var indexPathsToRemove = [IndexPath]()
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)

        } catch {
            print(error.localizedDescription)
        }
        
    }

    @objc func handleAddCompany() -> Void {
        let createCompanyController = CreateCompanyController()
        let navControler = CustomNavigationController(rootViewController: createCompanyController)
        navControler.modalPresentationStyle = .fullScreen
        
        createCompanyController.delegate = self
        present(navControler, animated: true, completion: nil)
    }
}
