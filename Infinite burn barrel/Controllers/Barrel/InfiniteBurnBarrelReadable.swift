//
//  InfiniteBurnBarrelReadings.swift
//  Infinite burn barrel
//
//  Created by Dejan on 18/03/2018.
//  Copyright © 2018 Mohamed Hage. All rights reserved.
//

import Foundation

protocol InfiniteBurnBarrelReadable {
    var fan: Bool { get set }
    var blower: Int { get set }
    var led: Bool { get set }
    
    var commands: [InfiniteBurnBarrelCommand] { get }
    
    func update(withCommand command: InfiniteBurnBarrelCommand)
}

class InfiniteBurnBarrelReading: InfiniteBurnBarrelReadable
{
    var fan: Bool = false
    var blower: Int = 0
    var led: Bool = false
    
    var commands: [InfiniteBurnBarrelCommand] {
        return [
            .fan(on: fan),
            .blower(value: blower),
            .led(on: led)
        ]
    }
    
    func update(withCommand command: InfiniteBurnBarrelCommand) {
        switch command {
        case .fan(let value): self.fan = value
        case .blower(let value): self.blower = value
        case .led(let value): self.led = value
        case .unknownCommand: print("Trying to update the object with an unknown command")
        }
    }
}
