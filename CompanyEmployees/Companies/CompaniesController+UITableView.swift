//
//  CompaniesController+UITableView.swift
//  CompanyEmployees
//
//  Created by user on 02.08.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import UIKit

extension CompaniesController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let company = companies[indexPath.row]
        let employeesControler = EmployeesControler()
        employeesControler.company = company
        
        navigationController?.pushViewController(employeesControler, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let company = self.companies[indexPath.row]
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CompanyCell
        
        let company = companies[indexPath.row]
        cell.company = company
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies available..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? 150 : 0
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
}
