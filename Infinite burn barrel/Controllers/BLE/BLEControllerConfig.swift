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
    var serviceUUID = ""
    var rxChannelUUID = ""
    var txChannelUUID = ""
}
