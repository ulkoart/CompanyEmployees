//
//  Service.swift
//  CompanyEmployees
//
//  Created by user on 12.08.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import Foundation

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
                
                jsonCompanies.forEach { (jsonCompany) in
                    print(jsonCompany.name)
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        print(jsonEmployee.name)
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
