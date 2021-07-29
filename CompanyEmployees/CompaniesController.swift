//
//  ViewController.swift
//  CompanyEmployees
//
//  Created by user on 13.07.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController, CreateCompanyControllerDelegatage {
    
    var companies = [Company]()
    
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let company = self.companies[indexPath.row]
            print("delete - \(company.name ?? "")")
            self.companies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(company)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction(action:indexPath:))
        editAction.backgroundColor = .lightRed
        editAction.backgroundColor = .darkBlue
        return [deleteAction, editAction]
    }
    
    func didEdidtCompany(company: Company) {
        let row = companies.firstIndex(of: company)
        let reloadIndexpath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexpath], with: .middle)
    }
    
    private func editHandlerFunction(action: UITableViewRowAction, indexPath:IndexPath) {
        print(#function)
        
        let editCompanyControler = CreateCompanyController()
        editCompanyControler.delegate = self
        editCompanyControler.company = companies[indexPath.row]
        let navController = CustomNavigationController(rootViewController: editCompanyControler)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    private func fetchCompanieis() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            companies.forEach { (comnapy) in
                print(comnapy.name ?? "")
            }
            
            self.companies = companies
            self.tableView.reloadData()
            
        } catch {
            print("failed fetch companies")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCompanieis()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        
        tableView.backgroundColor = .darkBlue
        // tableView.separatorStyle = .none
        tableView.separatorColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()
    }
    
    
    @objc func handleAddCompany() -> Void {
        let createCompanyController = CreateCompanyController()
        let navControler = CustomNavigationController(rootViewController: createCompanyController)
        navControler.modalPresentationStyle = .fullScreen
        
        createCompanyController.delegate = self
        present(navControler, animated: true, completion: nil)
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
        
        if let name = company.name, let founded = company.founded {
            // let local = Locale(identifier: "RU")
            // let foundedWithLocal = founded.description(with: local)
            
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd-MM-YYYY"
            let foundedString = dateFormater.string(from: founded)
            
            let dateString = "\(name) - Founded: \(foundedString)"
            cell.textLabel?.text = dateString
        } else {
            cell.textLabel?.text = company.name
        }
        
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
}
