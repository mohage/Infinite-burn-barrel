//
//  InfiniteBurnBarrelReadings.swift
//  Infinite burn barrel
//
//  Created by Dejan on 18/03/2018.
//  Copyright © 2018 Mohamed Hage. All rights reserved.
//

import Foundation

protocol InfiniteBurnBarrelReadable {
    var fan: Int { get set }
    var blower: Int { get set }
    var led: Int { get set }
    var speaker: Int { get set }
    var dumpLoad: Int { get set }
    var burnTemperature: Float { get }
    var surfaceTemperature: Float { get }
    var pumpTemperature: Float { get }
    var batteryVoltage: Float { get }
    var tegVoltage: Float { get }
    var batteryCurrent: Float { get }
    var tegCurrent: Float { get }
    
    var commands: [InfiniteBurnBarrelCommand] { get }
    
    func update(withCommand command: InfiniteBurnBarrelCommand)
}

class InfiniteBurnBarrelReading: InfiniteBurnBarrelReadable
{
    var fan: Int = 0
    var blower: Int = 0
    var led: Int = 0
    var speaker: Int = 0
    var dumpLoad: Int = 0
    var burnTemperature: Float = 0.0
    var surfaceTemperature: Float = 0.0
    var pumpTemperature: Float = 0.0
    var batteryVoltage: Float = 0.0
    var tegVoltage: Float = 0.0
    var batteryCurrent: Float = 0.0
    var tegCurrent: Float = 0.0
    
    var commands: [InfiniteBurnBarrelCommand] {
        return [
            .fan(value: fan),
            .blower(value: blower),
            .led(value: led),
            .speaker(value: speaker),
            .dumpLoad(value: dumpLoad),
            .burnTemperature(temperature: burnTemperature),
            .surfaceTemperature(temperature: surfaceTemperature),
            .pumpTemperature(temperature: pumpTemperature),
            .batteryVoltage(voltage: batteryVoltage),
            .tegVoltage(voltage: tegVoltage),
            .batteryCurrent(current: batteryCurrent),
            .tegCurrent(current: tegCurrent)
        ]
    }
    
    func update(withCommand command: InfiniteBurnBarrelCommand) {
        switch command {
        case .fan(let value): self.fan = value
        case .blower(let value): self.blower = value
        case .led(let value): self.led = value
        case .speaker(let value): self.speaker = value
        case .dumpLoad(let value): self.dumpLoad = value
        case .burnTemperature(let value): self.burnTemperature = value
        case .surfaceTemperature(let value): self.surfaceTemperature = value
        case .pumpTemperature(let value): self.pumpTemperature = value
        case .batteryVoltage(let value): self.batteryVoltage = value
        case .tegVoltage(let value): self.tegVoltage = value
        case .batteryCurrent(let value): self.batteryCurrent = value
        case .tegCurrent(let value): self.tegCurrent = value
        case .unknownCommand: print("Trying to update the object with an unknown command")
        }
    }
}
