//
//  CoreDataManager.swift
//  CompanyEmployees
//
//  Created by user on 19/07/2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Companies")
        container.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                fatalError("Loading of store failed: \(error)")
            }
        }
        return container
    }()
    
    func fetchCompanies() -> [Company] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
            
        } catch {
            print("failed fetch companies")
            return []
        }
    }
    
    func createEmployee(employeeName: String) -> (Employee?, Error?) {
        let context = persistentContainer.viewContext
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        employee.setValue(employeeName, forKey: "name")
        
        do {
            try context.save()
            return (employee, nil)
        } catch {
            print(error.localizedDescription)
            return (nil, error)
        }
        
    }
}
