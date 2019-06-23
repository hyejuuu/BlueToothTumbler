//
//  ConnectedBlueToothViewController.swift
//  BlueToothTumbler
//
//  Created by 이혜주 on 17/06/2019.
//  Copyright © 2019 leehyeju. All rights reserved.
//

import UIKit
import CoreBluetooth
import FirebaseDatabase

class ConnectedBlueToothViewController: UIViewController {
    
    var manager : CBCentralManager!
    //var peripheral: CBPeripheral!
    var myBluetoothPeripheral : CBPeripheral!
    var myCharacteristic : CBCharacteristic!
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
    
    let emptyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        return button
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
        
        manager = CBCentralManager(delegate: self, queue: nil)
//        self.socket = SocketManaging.socketManager.socket(forNamespace: "/bluetooth")
        indicatingTextLabel.text = "블루투스와 페어링 중 입니다."
        
//        Database.database().reference().
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
        view.addSubview(emptyButton)
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
        emptyButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
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
        
        emptyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        emptyButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func writeValue(value: String) {
        
        if isMyPeripheralConnected { //check if myPeripheral is connected to send data
//            let text: [UInt8] = [0x]
////            let byteArray = text.data(using: String.Encoding.macOSRoman)
//
//            guard let hex = text.data(using: .utf8) else {
//                assertionFailure()
//                return
//            }
//            let text = "503120302030203020302036"
//            var array: [Character] = ["P", "1", " ", "0", " ", "0", " ", "0", " ", "0", " ", "6"]
//            let data = NSData(bytes: &array, length: 12)
//            guard let data = "P1 0 0 0 0 6".data(using: .ascii) else {
//                assertionFailure()
//                return
//            }
//
            print(myCharacteristic.properties)
  
            guard let data = Data(hexString: "5031") else {
                assertionFailure()
                return
            }
            
            myBluetoothPeripheral.writeValue(data,
                                             for: myCharacteristic,
                                             type: .withResponse)    //실제 write 하는 부분
            
            print("dataSend")
        } else {
            print("Not connected")
        }
    }
    
    @objc func listCheckButtonClicked(_: UIBarButtonItem) {
        let listVC: BlueToothSearchingViewController = BlueToothSearchingViewController()
        listVC.peripherals = peripherals
        present(listVC, animated: true, completion: nil)
    }
    
    @objc func buttonClicked(_: UIButton) {
        writeValue(value: "")
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
            msg = "\(central.state)"
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
        if peripheral.name != nil {
            peripherals.append((peripheral: peripheral, RSSI: rssiValue))
            peripherals.sort { $0.RSSI < $1.RSSI }
        }
        guard let blueToothName = peripheral.name else { return }
        print("name: \(blueToothName)")
//        print("name: \(UserInformation.userId)")
        
//        if UserInformation.userId == "sangbum" {
            if blueToothName == "TUMBLER_2936" {
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
    
    //블투가 연결되었을 때 실행되는 메서드
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        isMyPeripheralConnected = true
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        indicatingTextLabel.text = "연결되었습니다."
    }
    
    //블투가 연결 해제 되었을때 실행되는 메서드
    func centralManager(_ central: CBCentralManager,
                        didDisconnectPeripheral peripheral: CBPeripheral,
                        error: Error?) {
        isMyPeripheralConnected = false
    }
}

extension ConnectedBlueToothViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        // 사용가능한 서비스를 발견했을 때
        
        if let servicePeripheral = peripheral.services { //get the services of the perifereal
            print("service is found")
            //블투 찾았을 때
            for service in servicePeripheral {
                
                //Then look for the characteristics of the services
                peripheral.discoverCharacteristics(nil, for: service)
                
            }
            // writeValue(value: "Z1")
        }
    }
    
    // 지정된 서비스의 특성을 발견할 때 호출됨.
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        print("called didUFor")
        if let characterArray = service.characteristics {

            for cc in characterArray {

                if(cc.uuid.uuidString == "6E400003-B5A3-F393-E0A9-E50E24DCCA9E") { // 내가 공부하기로는 스트링 전송은 FFE1을 사용해야하는것같음

                    myCharacteristic = cc //saved it to send data in another function.
                    print("char: \(myCharacteristic)")
                    peripheral.setNotifyValue(true, for: cc)
                    peripheral.readValue(for: cc) //to read the value of the characteristic
                }
            }
        }
    }
    
    
//     특정 특성의 값을 검색하거나 주변 장치가 해당 특성의 값이 변경되었음을 앱에 알릴 때 호출된다.
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        print("called didU")
        if (characteristic.uuid.uuidString == "6E400003-B5A3-F393-E0A9-E50E24DCCA9E") {

            let readValue = characteristic.value

            let value = (readValue! as NSData).bytes.bindMemory(to: Int.self, capacity: readValue!.count).pointee //used to read an Int value

            // writeValue(value: "5a")
            //sleep()
            if myBluetoothPeripheral.name == "TUMBLER_2936" {
                if value == 255 {
                    print("sangbum!")
                    print("getting value!!")
//                    self.socket.emit("sendMessage", "light on")
                }
            } else {
                if value == 90 {
                    print ("touched master device")
                    writeValue(value: "")
                }
            }
            print(value)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print(peripheral)
        print(characteristic)
        print(error)
    }
    
    
}

extension Data {
    init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hexString.index(hexString.startIndex, offsetBy: i*2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j..<k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
}
