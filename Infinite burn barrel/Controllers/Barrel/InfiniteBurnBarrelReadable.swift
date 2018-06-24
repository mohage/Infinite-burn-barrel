//
//  InfiniteBurnBarrelReadings.swift
//  Infinite burn barrel
//
//  Created by Dejan on 18/03/2018.
//  Copyright © 2018 Mohamed Hage. All rights reserved.
//

import Foundation

protocol InfiniteBurnBarrelReadable {
    var fan: Int { get }
    var blower: Int { get }
    var led: Int { get }
    var speaker: Int { get }
    var dumpLoad: Int { get }
    var instantHotWater: Int { get }
    var burnTemperature: Float { get }
    var desiredBurnTemperature: Float { get }
    var surfaceTemperature: Float { get }
    var pumpTemperature: Float { get }
    var desiredPumpTemperature: Float { get }
    var heatSinkTemperature: Float { get }
    var batteryVoltage: Float { get }
    var tegVoltage: Float { get }
    var batteryCurrent: Float { get }
    var tegCurrent: Float { get }
    var custom: String { get }
    var listen: String { get }
    
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
    var instantHotWater: Int = 0
    var burnTemperature: Float = 0.0
    var desiredBurnTemperature: Float = 0.0
    var surfaceTemperature: Float = 0.0
    var pumpTemperature: Float = 0.0
    var desiredPumpTemperature: Float = 0.0
    var heatSinkTemperature: Float = 0.0
    var batteryVoltage: Float = 0.0
    var tegVoltage: Float = 0.0
    var batteryCurrent: Float = 0.0
    var tegCurrent: Float = 0.0
    var custom: String = ""
    var listen: String = ""
    
    // These commands will be sent to Arduino. There's no need to send all of them.
    var commands: [InfiniteBurnBarrelCommand] {
        return [
            .led(value: led),
            .speaker(value: speaker),
            .instantHotWater(value: instantHotWater),
            .desiredBurnTemperature(temperature: desiredBurnTemperature),
            .desiredPumpTemperature(temperature: desiredPumpTemperature)
        ]
    }
    
    func update(withCommand command: InfiniteBurnBarrelCommand) {
        switch command {
        case .fan(let value): self.fan = value
        case .blower(let value): self.blower = value
        case .led(let value): self.led = value
        case .speaker(let value): self.speaker = value
        case .dumpLoad(let value): self.dumpLoad = value
        case .instantHotWater(let value): self.instantHotWater = value
        case .burnTemperature(let value): self.burnTemperature = value
        case .desiredBurnTemperature(let value): self.desiredBurnTemperature = value
        case .surfaceTemperature(let value): self.surfaceTemperature = value
        case .pumpTemperature(let value): self.pumpTemperature = value
        case .desiredPumpTemperature(let value): self.desiredPumpTemperature = value
        case .heatSinkTemperature(let value): self.heatSinkTemperature = value
        case .batteryVoltage(let value): self.batteryVoltage = value
        case .tegVoltage(let value): self.tegVoltage = value
        case .batteryCurrent(let value): self.batteryCurrent = value
        case .tegCurrent(let value): self.tegCurrent = value
        case .custom(let text): self.custom = text
        case .listen(let text): self.listen = text
        case .unknownCommand: print("Trying to update the object with an unknown command")
        }
    }
}
