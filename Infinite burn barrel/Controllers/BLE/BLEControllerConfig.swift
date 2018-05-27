//
//  BLEControllerConfig.swift
//  Infinite burn barrel
//
//  Created by Dejan on 18/03/2018.
//  Copyright © 2018 Mohamed Hage. All rights reserved.
//

import Foundation

protocol BLEControllerConfigurable {
    var serviceUUID: String { get }
    var rxChannelUUID: String { get }
    var txChannelUUID: String { get }
}

struct BLEControllerConfig: BLEControllerConfigurable {
    var serviceUUID = "ffe0"
    var rxChannelUUID = "ffe1"
    var txChannelUUID = "ffe1"
}

struct ADAFruitBLEControllerConfig: BLEControllerConfigurable {
    var serviceUUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e"
    var rxChannelUUID = "6e400003-b5a3-f393-e0a9-e50e24dcca9e"
    var txChannelUUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e"
}
