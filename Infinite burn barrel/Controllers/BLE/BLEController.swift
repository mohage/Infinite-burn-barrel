//
//  BLEController.swift
//  Infinite burn barrel
//
//  Created by Dejan on 18/03/2018.
//  Copyright © 2018 Mohamed Hage. All rights reserved.
//

import Foundation
import CoreBluetooth
import CocoaLumberjack

public protocol BLEControllable {
    
    func startScanning()
    func stopScanning()
    
    func connect()
    func disconnect()
    
    func sendData(_ dataString: String)
    
    var onConnected: (() -> ())? { get set }
    var onDisconnected: (() -> ())? { get set }
    var onDataReceived: ((String) -> ())? { get set }
}

class BLEController: NSObject, BLEControllable {
    
    fileprivate let configuration: BLEControllerConfigurable
    
    private var shouldStartScanning = false
    private var shouldConnect = true
    
    private var centralManager: CBCentralManager?
    private var isCentralManagerReady: Bool {
        get {
            guard let centralManager = centralManager else {
                return false
            }
            return centralManager.state != .poweredOff
                && centralManager.state != .unauthorized
                && centralManager.state != .unsupported
        }
    }
    
    private var connectingPeripheral: CBPeripheral?
    private var connectedPeripheral: CBPeripheral?
    
    private var service: CBService? {
        return
            connectedPeripheral?
                .services?
                .filter({ $0.uuid.uuidString.uppercased() == configuration.serviceUUID.cbuuid.uuidString.uppercased() })
                .first
    }
    
    private var txCharacteristic: CBCharacteristic? {
        return
            service?
                .characteristics?
                .filter({ $0.uuid.uuidString.uppercased() == configuration.txChannelUUID.cbuuid.uuidString.uppercased() })
                .first
    }
    
    var onConnected: (() -> ())?
    var onDisconnected: (() -> ())?
    var onDataReceived: ((String) -> ())?
    
    init(_ config: BLEControllerConfigurable = BLEControllerConfig()) {
        configuration = config
        
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.global(qos: .background))
        startScanning()
    }
    
    func startScanning() {
        guard let centralManager = centralManager, isCentralManagerReady == true, shouldConnect == true else {
            return
        }
        
        if centralManager.state != .poweredOn {
            shouldStartScanning = true
        } else {
            shouldStartScanning = false
            centralManager.scanForPeripherals(withServices: [configuration.serviceUUID.cbuuid], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
            DDLogVerbose("[BLEController] Did start scanning for peripherals")
        }
    }
    
    func stopScanning() {
        shouldStartScanning = false
        centralManager?.stopScan()
    }
    
    func connect() {
        shouldConnect = true
        startScanning()
    }
    
    func disconnect() {
        guard
            let peripheral = connectedPeripheral
            else {
                return
        }
        
        shouldConnect = false
        centralManager?.cancelPeripheralConnection(peripheral)
        DDLogVerbose("[BLEController] Did cancel peripheral connection")
    }
    
    func sendData(_ dataString: String) {
        guard
            let data = dataString.data(using: .utf8),
            let txChar = txCharacteristic
            else {
                return
        }
        
        connectedPeripheral?.writeValue(data, for: txChar, type: .withoutResponse)
    }
}

// MARK: - CBCentralManagerDelegate
extension BLEController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        DDLogVerbose("[BLEController] Central manager did update state - state: \(central.state)")
        if central.state == .poweredOn {
            if self.shouldStartScanning {
                self.startScanning()
            }
        } else {
            self.connectingPeripheral = nil
            if let connectedPeripheral = self.connectedPeripheral {
                central.cancelPeripheralConnection(connectedPeripheral)
            }
            self.shouldStartScanning = true
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        DDLogVerbose("[BLEController] Central manager did discover peripheral: \(peripheral)")
        self.connectingPeripheral = peripheral
        central.connect(peripheral, options: nil)
        self.stopScanning()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        DDLogVerbose("[BLEController] Central manager did connect peripheral: \(peripheral)")
        self.connectedPeripheral = peripheral
        self.connectingPeripheral = nil
        
        peripheral.delegate = self
        peripheral.discoverServices([configuration.serviceUUID.cbuuid])
        
        onConnected?()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        DDLogVerbose("[BLEController] Central manager failed to connect with error: \(error)")
        self.connectingPeripheral = nil
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        DDLogVerbose("[BLEController] Central manager did disconnect peripheral: \(peripheral)")
        self.connectedPeripheral = nil
        self.startScanning()
        
        onDisconnected?()
    }
}

// MARK: - CBPeripheralDelegate
extension BLEController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        DDLogVerbose("[BLEController] Did discover services")
        if let service = peripheral.services?.filter({ $0.uuid.uuidString.uppercased() == configuration.serviceUUID.cbuuid.uuidString.uppercased() }).first {
            peripheral.discoverCharacteristics([configuration.rxChannelUUID.cbuuid, configuration.txChannelUUID.cbuuid], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        DDLogVerbose("[BLEController] Did discover characteristics")
        setNotification(peripheral, service, configuration.rxChannelUUID.cbuuid, true)
        setNotification(peripheral, service, configuration.txChannelUUID.cbuuid, true)
    }
    
    private func setNotification(_ peripheral: CBPeripheral, _ service: CBService, _ characteristic: CBUUID, _ value: Bool) {
        if let char = service.characteristics?.filter({ $0.uuid.uuidString.uppercased() == characteristic.uuidString.uppercased()}).first {
            peripheral.setNotifyValue(value, for: char)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard
            let receivedData = characteristic.value,
            characteristic.uuid.uuidString.uppercased() == configuration.rxChannelUUID.cbuuid.uuidString.uppercased()
            else {
                return
        }
        
        DDLogVerbose("[BLEController] Did receive data for characterictic - data: \(receivedData)")
        if let dataString = String(data: receivedData, encoding: .utf8) {
            onDataReceived?(dataString)
        }
    }
}

// MARK: - Utility Extensions
private extension String {
    var cbuuid: CBUUID {
        return CBUUID(string: self)
    }
}
