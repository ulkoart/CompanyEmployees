//
//  UIViewController+Helpers.swift
//  CompanyEmployees
//
//  Created by user on 03.08.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupPlusButtonNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: selector)
    }
    
    func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
