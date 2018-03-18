//
//  InfiniteBurnBarrelController.swift
//  Infinite burn barrel
//
//  Created by Dejan on 18/03/2018.
//  Copyright © 2018 Mohamed Hage. All rights reserved.
//

import Foundation

private struct Weak<T: AnyObject> {
    weak var object: T?
}

protocol InfiniteBurnBarrelDelegate: AnyObject {
    func infiniteBurnBarrelDidConnect(_ barrel: InfiniteBurnBarrelControllable)
    func infiniteBurnBarrelDidDisconnect(_ barrel: InfiniteBurnBarrelControllable)
    func infiniteBurnBarrelDidReceiveReadings(_ barrel: InfiniteBurnBarrelControllable, _ readings: InfiniteBurnBarrelReadable)
}

protocol InfiniteBurnBarrelControllable {
    var lastReading: InfiniteBurnBarrelReadable? { get }
    func sendReadings(_ readings: InfiniteBurnBarrelReadable)
    
    func addDelegate(_ delegate: InfiniteBurnBarrelDelegate)
    func removeDelegate(_ delegate: InfiniteBurnBarrelDelegate)
}

class InfiniteBurnBarrelController: InfiniteBurnBarrelControllable
{
    private(set) var lastReading: InfiniteBurnBarrelReadable?
    
    private var bleController: BLEControllable
    private var factory: InfiniteBurnBarrelFactoryProtocol
    
    init(_ bleController: BLEControllable = BLEController(),
         _ factory: InfiniteBurnBarrelFactoryProtocol = InfiniteBurnBarrelFactory())
    {
        self.bleController = bleController
        self.factory = factory
        self.setupController()
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
            self.lastReading = self.factory.fromString(string)
            if let reading = self.lastReading {
                self.controllerDelegates.forEach({ (delegate) in
                    DispatchQueue.main.async {
                        delegate.infiniteBurnBarrelDidReceiveReadings(self, reading)
                    }
                })
            }
        }
    }
    
    func sendReadings(_ readings: InfiniteBurnBarrelReadable) {
        guard let dataString = factory.toString(readings) else {
            return
        }
        
        bleController.sendData(dataString)
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
