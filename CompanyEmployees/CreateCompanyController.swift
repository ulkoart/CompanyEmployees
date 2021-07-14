//
//  CreateCompanyController.swift
//  CompanyEmployees
//
//  Created by user on 14.07.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import UIKit

class CreateCompanyController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .darkBlue
        navigationItem.title = "Create Company"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
