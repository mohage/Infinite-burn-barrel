//
//  InfiniteBurnBarrelController.swift
//  Infinite burn barrel
//
//  Created by Dejan on 18/03/2018.
//  Copyright © 2018 Mohamed Hage. All rights reserved.
//

import Foundation
import CocoaLumberjack

private struct Weak<T: AnyObject> {
    weak var object: T?
}

protocol InfiniteBurnBarrelDelegate: AnyObject {
    func infiniteBurnBarrelDidConnect(_ barrel: InfiniteBurnBarrelControllable)
    func infiniteBurnBarrelDidDisconnect(_ barrel: InfiniteBurnBarrelControllable)
    func infiniteBurnBarrelDidReceiveReadings(_ barrel: InfiniteBurnBarrelControllable, _ readings: InfiniteBurnBarrelReadable)
}

protocol InfiniteBurnBarrelControllable
{
    func connect()
    func disconnect()
    
    var lastReading: InfiniteBurnBarrelReadable? { get }
    func sendCommand(_ command: InfiniteBurnBarrelCommand)
    
    func addDelegate(_ delegate: InfiniteBurnBarrelDelegate)
    func removeDelegate(_ delegate: InfiniteBurnBarrelDelegate)
}

class InfiniteBurnBarrelController: InfiniteBurnBarrelControllable
{
    private(set) var lastReading: InfiniteBurnBarrelReadable?
    
    private var bleController: BLEControllable
    
    init(_ bleController: BLEControllable = BLEController()) {
        self.bleController = bleController
        self.setupController()
        self.lastReading = InfiniteBurnBarrelReading()
    }
    
    private func setupController()
    {
        bleController.onConnected = {
            self.controllerDelegates.forEach({ (delegate) in
                DispatchQueue.main.async {
                    delegate.infiniteBurnBarrelDidConnect(self)
                }
            })
        }
        
        bleController.onDisconnected = {
            self.controllerDelegates.forEach({ (delegate) in
                DispatchQueue.main.async {
                    delegate.infiniteBurnBarrelDidDisconnect(self)
                }
            })
        }
        
        bleController.onDataReceived = { (string) in
            DDLogInfo("[Barrel Controller] Did receive data: \(string)")
            self.lastReading?.update(withCommand: InfiniteBurnBarrelCommand.command(fromString: string)) // TODO: Decouple the command processor from the class.
            DDLogInfo("[Barrel Controller] Did parse lastReading: \(self.lastReading)")
            
            if let reading = self.lastReading {
                self.controllerDelegates.forEach({ (delegate) in
                    DispatchQueue.main.async {
                        delegate.infiniteBurnBarrelDidReceiveReadings(self, reading)
                    }
                })
            }
        }
    }
    
    func connect() {
        bleController.connect()
    }
    
    func disconnect() {
        bleController.disconnect()
    }
    
    func sendCommand(_ command: InfiniteBurnBarrelCommand) {
        self.bleController.sendData(command.string)
    }
    
    // MARK: - Delegates Management
    private var delegates: [Weak<AnyObject>] = []
    private var controllerDelegates: [InfiniteBurnBarrelDelegate] {
        return delegates.flatMap { $0.object as? InfiniteBurnBarrelDelegate }
    }
    
    func addDelegate(_ delegate: InfiniteBurnBarrelDelegate) {
        delegates.append(Weak(object: delegate))
    }
    
    func removeDelegate(_ delegate: InfiniteBurnBarrelDelegate) {
        if let index = delegates.index(where: { $0.object === delegate }) {
            delegates.remove(at: index)
        }
    }
}
