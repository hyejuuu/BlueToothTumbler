//
//  BlueToothSearchingViewController.swift
//  BlueToothTumbler
//
//  Created by 이혜주 on 17/06/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit
import CoreBluetooth

let cellIdentifier: String = "peripheralCell"
class BlueToothSearchingViewController: UIViewController {

    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
    
    let searchingTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupTableView()
    }
    
    private func setupLayout() {
        view.addSubview(searchingTableView)
        
        searchingTableView.topAnchor.constraint(
            equalTo: view.topAnchor).isActive = true
        searchingTableView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor).isActive = true
        searchingTableView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor).isActive = true
        searchingTableView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupTableView() {
        searchingTableView.delegate = self
        searchingTableView.dataSource = self
        searchingTableView.register(BlueToothPeripheralTableViewCell.self,
                                    forCellReuseIdentifier: cellIdentifier)
    }

}

extension BlueToothSearchingViewController: UITableViewDelegate {
    
}

extension BlueToothSearchingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: BlueToothPeripheralTableViewCell
            = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                            for: indexPath) as? BlueToothPeripheralTableViewCell else {
            return .init()
        }
        
        if peripherals[indexPath.row].peripheral.name != nil {
            guard let name = peripherals[indexPath.row].peripheral.name else {
                return .init()
            }
            // guard let rssi = peripherals[indexPath.row].RSSI else {return UITableViewCell.init()}
            
            cell.blueToothPeripheralNameLabel.text = "name: \(name)"
            cell.blueToothRSSILabel.text = "strength: \(peripherals[indexPath.row].RSSI)"
        } else {
            cell.blueToothPeripheralNameLabel.text = "no name"
        }
        return cell
    }
}
