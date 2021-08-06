//
//  EmployeesControler.swift
//  CompanyEmployees
//
//  Created by user on 03.08.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import UIKit
import CoreData

class IndentedLabel: UILabel {
    override func draw(_ rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let cutomRect = rect.inset(by: insets)
        super.drawText(in: cutomRect)
    }
}

class EmployeesControler: UITableViewController, CreateEmployeeControllerDelegate {
    
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        if section == 0 {
            label.text = "Short names"
        } else {
            label.text = "Long names"
        }
        
        label.textColor = .darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = .lightBlue
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    var shortNameEmployees = [Employee]()
    var longNameEmployees = [Employee]()
    
    private func fetchEmployees() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else {return}
        
        shortNameEmployees = companyEmployees.filter { (employee) -> Bool in
            if let count = employee.name?.count {
                return count < 6
            }
            return false
        }
        
        longNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count > 6
            }
            return false
        })
        
        // self.employees = companyEmployees
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return shortNameEmployees.count
        }
        
        return longNameEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        
        
       //  let employee = employees[indexPath.row]
        let employee = indexPath.section == 0 ?
            shortNameEmployees[indexPath.row] :
            longNameEmployees[indexPath.row]
        
        cell.textLabel?.text = employee.name
        
        if let birthday = employee.employeeInformation?.birthday {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd-MM-YYYY"
            cell.textLabel?.text = "\(employee.name ?? "")    \(dateFormater.string(from: birthday))"
        }
        
        //        if let taxId = employee.employeeInformation?.taxId {
        //            cell.textLabel?.text = "\(employee.name ?? "")    \(taxId)"
        //        }
        
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        return cell
        
    }
    
    let cellId = "hh"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEmployees()
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .darkBlue
        tableView.separatorInset = .zero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        setupPlusButtonNavBar(selector: #selector(handleAdd))
        
        
    }
    
    @objc func handleAdd() -> Void {
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.company = company
        createEmployeeController.delegate = self
        let navControler = CustomNavigationController(rootViewController: createEmployeeController)
        navControler.modalPresentationStyle = .fullScreen
        
        present(navControler, animated: true, completion: nil)
        
    }
    
}
