//
//  SettingsCell.swift
//  chatcanvas
//
//  Created by Müge Deniz on 23.04.2025.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withTitle title: String, imageName: String) {
        textLabel?.text = title
        textLabel?.textColor = .white
        
        // Load the image and set it to template mode
        if let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate) {
            imageView?.image = image
            imageView?.tintColor = .white
        }
        
        // Remove the default accessory
        accessoryType = .none
        
        // Create a custom accessory view with a white chevron
        let chevronImage = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        let chevronImageView = UIImageView(image: chevronImage)
        chevronImageView.tintColor = .white
        chevronImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        accessoryView = chevronImageView
        
        backgroundColor = .black
    }
}
