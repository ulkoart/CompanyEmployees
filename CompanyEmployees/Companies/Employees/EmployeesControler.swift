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
        
        guard let section = employeeTypes.firstIndex(of: employee.type!) else { return }
        let row = allEmployees[section].count        
        let insertionIndexPath: IndexPath = IndexPath(row: row, section: section)
        allEmployees[section].append(employee)
        tableView.insertRows(at: [insertionIndexPath], with: .middle)
    }
    
    var company: Company?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
       
        label.text = employeeTypes[section]
        label.textColor = .darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = .lightBlue
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    var allEmployees = [[Employee]]()
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagment.rawValue,
        EmployeeType.Staff.rawValue
    ]
    
    private func fetchEmployees() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else {return}
        
        allEmployees = []
        employeeTypes.forEach { (employeeType) in
            allEmployees.append(companyEmployees.filter { $0.type == employeeType })
        }
        
        // let executives = companyEmployees.filter { $0.type == EmployeeType.Executive.rawValue }
        // let seniorManagement = companyEmployees.filter { $0.type == EmployeeType.SeniorManagment.rawValue }
        // let staff = companyEmployees.filter { $0.type == EmployeeType.Staff.rawValue }
        // allEmployees = [executives, seniorManagement, staff]
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let employee = allEmployees[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = employee.name
        
        if let birthday = employee.employeeInformation?.birthday {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd-MM-YYYY"
            cell.textLabel?.text = "\(employee.name ?? "")    \(dateFormater.string(from: birthday))"
        }
        
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
