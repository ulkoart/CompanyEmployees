//
//  CustomMigrationPolicy.swift
//  CompanyEmployees
//
//  Created by user on 13.08.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//


import CoreData

class CustomMigrationPolicy: NSEntityMigrationPolicy {
    
    @objc func transformNumEmployees(forNum: NSNumber) -> String {
        if forNum.intValue < 150 {
            return "small"
        } else {
            return "very large"
        }
    }
    
}
