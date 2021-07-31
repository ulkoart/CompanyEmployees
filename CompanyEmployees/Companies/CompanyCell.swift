//
//  CompanyCell.swift
//  CompanyEmployees
//
//  Created by user on 30.07.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    var company: Company? {
        didSet {
            nameFoundedLabel.text = company?.name
            
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
            
            if let name = company?.name, let founded = company?.founded {
                // let local = Locale(identifier: "RU")
                // let foundedWithLocal = founded.description(with: local)
    
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "dd-MM-YYYY"
                let foundedString = dateFormater.string(from: founded)
    
                let dateString = "\(name) - Founded: \(foundedString)"
                nameFoundedLabel.text = dateString
            } else {
                nameFoundedLabel.text = company?.name
            }
                    
        }
    }
    
    let companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.darkBlue.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    let nameFoundedLabel: UILabel = {
        let label = UILabel()
        label.text = "COMAPY NAME"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .tealColor
        
        addSubview(companyImageView)
        companyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        companyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(nameFoundedLabel)
        nameFoundedLabel.leftAnchor.constraint(equalTo: companyImageView.rightAnchor, constant: 8).isActive = true
        nameFoundedLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameFoundedLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameFoundedLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
