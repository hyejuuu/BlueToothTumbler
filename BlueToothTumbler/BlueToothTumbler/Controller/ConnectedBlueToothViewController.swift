//
//  ConnectedBlueToothViewController.swift
//  BlueToothTumbler
//
//  Created by 이혜주 on 17/06/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit
import CoreBluetooth

class ConnectedBlueToothViewController: UIViewController {
    
    var manager : CBCentralManager!
    //var peripheral: CBPeripheral!
    var myBluetoothPeripheral : CBPeripheral!
//    var myCharacteristic : CBCharacteristic!
    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
    var isMyPeripheralConnected = false
//    var socket: SocketIOClient!
    
    let indicatingTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let btImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "bluetooth")
        return imageView
    }()
    
    let loadingView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        return containerView
    }()
    
    lazy var doneBarButtonItem = UIBarButtonItem(title: "Done",
                                            style: .done,
                                            target: self,
                                            action: #selector(listCheckButtonClicked(_:)))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadingView.aj_showDotLoadingIndicator()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        
        self.manager = CBCentralManager(delegate: self, queue: nil)
//        self.socket = SocketManaging.socketManager.socket(forNamespace: "/bluetooth")
        self.indicatingTextLabel.text = "블루투스와 페어링 중 입니다."
        
//        socket.connect()
//        socket.on(clientEvent: .connect) {[weak self] data, ack in
//            print("socket BT connected")
//        }
//        socket.on("receiveMessage") {(data,ack) in
//            if UserInformation.userId == "sangbum" {
//
//            } else {
//                self.writeValue(value: "some")
//            }
//        }
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(btImageView)
        view.addSubview(loadingView)
        view.addSubview(indicatingTextLabel)
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
        btImageView.widthAnchor.constraint(
            equalToConstant: 130).isActive = true
        btImageView.heightAnchor.constraint(
            equalToConstant: 130).isActive = true
        btImageView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 100).isActive = true
        btImageView.centerXAnchor.constraint(
            equalTo: self.view.centerXAnchor).isActive = true
        
        loadingView.widthAnchor.constraint(
            equalToConstant: 120).isActive = true
        loadingView.heightAnchor.constraint(
            equalToConstant: 120).isActive = true
        loadingView.centerXAnchor.constraint(
            equalTo: self.view.centerXAnchor).isActive = true
        loadingView.topAnchor.constraint(
            equalTo: self.btImageView.bottomAnchor,
            constant: 12).isActive = true
        
        indicatingTextLabel.topAnchor.constraint(
            equalTo: self.loadingView.bottomAnchor,
            constant: 24).isActive = true
        indicatingTextLabel.centerXAnchor.constraint(
            equalTo: self.view.centerXAnchor).isActive = true
        indicatingTextLabel.widthAnchor.constraint(
            equalTo: self.view.widthAnchor,
            multiplier: 0.8).isActive = true
    }
    
    @objc func listCheckButtonClicked(_: UIBarButtonItem) {
        let listVC: BlueToothSearchingViewController = BlueToothSearchingViewController()
        listVC.peripherals = peripherals
        present(listVC, animated: true, completion: nil)
    }
}

extension ConnectedBlueToothViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var msg = ""
        
        switch central.state {
        case .poweredOff:
            msg = "Bluetooth is Off"
        case .poweredOn:
            msg = "Bluetooth is On"
            manager.scanForPeripherals(withServices: nil, options: nil)
        case .unsupported:
            msg = "Not Supported"
        default:
            msg = "😔"
        }
        
        print("STATE: " + msg)
    }
    
    // 스캔하는 동안 central manager가 주변 장치를 검색할 때 호출됨.
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print("Name: \(peripheral.name)") //print the names of all peripherals connected.
        print("searching!!!!!!!")
        //print("\(RSSI)")
        
        for alreadyInsideOfarray in peripherals {
            if alreadyInsideOfarray.peripheral.identifier == peripheral.identifier { return }
        }
        
        let rssiValue = RSSI.floatValue
        //if peripheral.name != nil {
        peripherals.append((peripheral: peripheral, RSSI: rssiValue))
        // 신호가 강한 순러대로 정렬
        peripherals.sort { $0.RSSI < $1.RSSI }
        //tableView.reloadData()
        //  }
        guard let blueToothName = peripheral.name else {return}
        print("name: \(blueToothName)")
//        print("name: \(UserInformation.userId)")
        
//        if UserInformation.userId == "sangbum" {
            if blueToothName == "이혜주의 iPhone" {
                print("sangbum logged in")
                myBluetoothPeripheral = peripheral     //save peripheral
                myBluetoothPeripheral.delegate = self
                
                manager.stopScan()                          //stop scanning for peripherals
                manager.connect(myBluetoothPeripheral, options: nil) //connect to my peripheral
                print("sangbum logged in")
                
            } else if blueToothName == "[SABRE]" {
                
                myBluetoothPeripheral = peripheral     //save peripheral
                myBluetoothPeripheral.delegate = self
                
                manager.stopScan()                          //stop scanning for peripherals
                manager.connect(myBluetoothPeripheral, options: nil) //connect to my peripheral
                
            }
//        } else {
//            if blueToothName == "[SABRE]" {
//
//                self.myBluetoothPeripheral = peripheral     //save peripheral
//                self.myBluetoothPeripheral.delegate = self
//
//                manager.stopScan()                          //stop scanning for peripherals
//                manager.connect(myBluetoothPeripheral, options: nil) //connect to my peripheral
//
//            }
//        }
        
    }
    
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        isMyPeripheralConnected = true //블투가 연결되었을 때 실행되는 메서드
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        indicatingTextLabel.text = "연결되었습니다."
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDisconnectPeripheral peripheral: CBPeripheral,
                        error: Error?) {
        isMyPeripheralConnected = false //블투가 연결 해제 되었을때 실행되는 메서드
    }
}

extension ConnectedBlueToothViewController: CBPeripheralDelegate {
    
}
