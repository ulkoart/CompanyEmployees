//
//  Service.swift
//  CompanyEmployees
//
//  Created by user on 12.08.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import Foundation
import CoreData

struct Service {
    
    static let shared = Service()
    
    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompaniesFromServer() -> Void {
        print(#function)
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, error) in
            if let error = error {
                print("Faild download")
                return
            }
            
            guard let data = data else { return }
            // let string = String(data: data, encoding: .utf8)
            
            let jsonDecoder = JSONDecoder()
            do {
                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
                
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
                
                jsonCompanies.forEach { (jsonCompany) in
                    print(jsonCompany.name)
                    
                    let company = Company(context: privateContext)
                    company.name = jsonCompany.name
                    let dateFormater = DateFormatter()
                    dateFormater.dateFormat = "MM/dd/yyyy"
                    
                    if let stringFounded = jsonCompany.founded {
                        let foundedDate = dateFormater.date(from: stringFounded)
                        company.founded = foundedDate
                    }
                    
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        let employee = Employee(context: privateContext)
                        employee.fullName = jsonEmployee.name
                        employee.type = jsonEmployee.type
                        employee.company = company
                        
                        let employeeInformation = EmployeeInformation(context: privateContext)
                        
                        let birthdayDate = dateFormater.date(from: jsonEmployee.birthday)
                        employeeInformation.birthday = birthdayDate
                        employee.employeeInformation = employeeInformation
 
                        
                        do {
                            try privateContext.save()
                            try privateContext.parent?.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    })
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

struct JSONCompany: Decodable {
    let name: String
    let founded: String?
    let employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    let name: String
    let type: String
    let birthday: String
}
