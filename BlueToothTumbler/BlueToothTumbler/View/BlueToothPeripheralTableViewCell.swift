//
//  BlueToothPeripheralTableViewCell.swift
//  BlueToothTumbler
//
//  Created by 이혜주 on 17/06/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit

class BlueToothPeripheralTableViewCell: UITableViewCell {
    
    let blueToothPeripheralNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let blueToothRSSILabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override func prepareForReuse() {
        self.blueToothPeripheralNameLabel.text = ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
}

extension BlueToothPeripheralTableViewCell {
    
    private func setupLayout() {
        contentView.addSubview(blueToothPeripheralNameLabel)
        contentView.addSubview(blueToothRSSILabel)
        
        blueToothPeripheralNameLabel.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        blueToothPeripheralNameLabel.centerYAnchor.constraint(
            equalTo: contentView.centerYAnchor).isActive = true
        
        blueToothRSSILabel.leadingAnchor.constraint(
            equalTo: blueToothPeripheralNameLabel.trailingAnchor,
            constant: 16).isActive = true
        blueToothRSSILabel.centerYAnchor.constraint(
            equalTo: contentView.centerYAnchor).isActive = true
        
    }
}
