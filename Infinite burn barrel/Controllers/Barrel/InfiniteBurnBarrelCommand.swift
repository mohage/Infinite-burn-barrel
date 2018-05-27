//
//  InfiniteBurnBarrelCommand.swift
//  Infinite burn barrel
//
//  Created by Dejan on 18/03/2018.
//  Copyright © 2018 Mohamed Hage. All rights reserved.
//

import Foundation

enum CommandKey: String {
    case fan
    case blower = "blo"
    case led
    case speaker = "spk"
    case dumpLoad = "dump"
    case burnTemperature = "btemp"
    case surfaceTemperature = "stemp"
    case pumpTemperature = "ptemp"
    case batteryVoltage = "batvolt"
    case tegVoltage = "tegvolt"
    case batteryCurrent = "batcurr"
    case tegCurrent = "tegcurr"
}

enum InfiniteBurnBarrelCommand: Equatable, Hashable
{
    case unknownCommand
    case fan(value: Int)
    case blower(value: Int)
    case led(value: Int)
    case speaker(value: Int)
    case dumpLoad(value: Int)
    case burnTemperature(temperature: Float)
    case surfaceTemperature(temperature: Float)
    case pumpTemperature(temperature: Float)
    case batteryVoltage(voltage: Float)
    case tegVoltage(voltage: Float)
    case batteryCurrent(current: Float)
    case tegCurrent(current: Float)
    
    var string: String {
        get {
            switch self {
            case .unknownCommand: return "unknown"
            case .fan(let value): return "\(CommandKey.fan.rawValue)_\(value)"
            case .blower(let value): return "\(CommandKey.blower.rawValue)_\(value)"
            case .led(let value): return "\(CommandKey.led.rawValue)_\(value)"
            case .speaker(let value): return "\(CommandKey.speaker.rawValue)_\(value)"
            case .dumpLoad(let value): return "\(CommandKey.dumpLoad.rawValue)_\(value)"
            case .burnTemperature(let value): return "\(CommandKey.burnTemperature.rawValue)_\(value)"
            case .surfaceTemperature(let value): return "\(CommandKey.surfaceTemperature.rawValue)_\(value)"
            case .pumpTemperature(let value): return "\(CommandKey.pumpTemperature.rawValue)_\(value)"
            case .batteryVoltage(let value): return "\(CommandKey.batteryVoltage.rawValue)_\(value)"
            case .tegVoltage(let value): return "\(CommandKey.tegVoltage.rawValue)_\(value)"
            case .batteryCurrent(let value): return "\(CommandKey.batteryCurrent.rawValue)_\(value)"
            case .tegCurrent(let value): return "\(CommandKey.tegCurrent.rawValue)_\(value)"
            }
        }
    }
    
    static func command(fromString string: String) -> InfiniteBurnBarrelCommand
    {
        let keyValue = string.split(separator: "_")
        
        if let key = keyValue.first {
            if key == CommandKey.fan.rawValue, let value = keyValue.last, let intValue = Int(value) {
                return .fan(value: intValue)
            } else if key == CommandKey.blower.rawValue, let value = keyValue.last, let intValue = Int(value) {
                return .blower(value: intValue)
            } else if key == CommandKey.led.rawValue, let value = keyValue.last, let intValue = Int(value) {
                return .led(value: intValue)
            } else if key == CommandKey.speaker.rawValue, let value = keyValue.last, let intValue = Int(value) {
                return .speaker(value: intValue)
            } else if key == CommandKey.dumpLoad.rawValue, let value = keyValue.last, let intValue = Int(value) {
                return .dumpLoad(value: intValue)
            } else if key == CommandKey.burnTemperature.rawValue, let value = keyValue.last, value != "nan" {
                return .burnTemperature(temperature: Float(value) ?? 0.0)
            } else if key == CommandKey.surfaceTemperature.rawValue, let value = keyValue.last, value != "nan" {
                return .surfaceTemperature(temperature: Float(value) ?? 0.0)
            } else if key == CommandKey.pumpTemperature.rawValue, let value = keyValue.last, value != "nan" {
                return .pumpTemperature(temperature: Float(value) ?? 0.0)
            } else if key == CommandKey.batteryVoltage.rawValue, let value = keyValue.last, value != "nan" {
                return .batteryVoltage(voltage: Float(value) ?? 0.0)
            } else if key == CommandKey.tegVoltage.rawValue, let value = keyValue.last, value != "nan" {
                return .tegVoltage(voltage: Float(value) ?? 0.0)
            } else if key == CommandKey.batteryCurrent.rawValue, let value = keyValue.last, value != "nan" {
                return .batteryCurrent(current: Float(value) ?? 0.0)
            } else if key == CommandKey.tegCurrent.rawValue, let value = keyValue.last, value != "nan" {
                return .tegCurrent(current: Float(value) ?? 0.0)
            }
        }
        
        return .unknownCommand
    }
    
    // MARK: - Equatable
    public static func ==(lhs: InfiniteBurnBarrelCommand, rhs: InfiniteBurnBarrelCommand) -> Bool {
        switch (lhs, rhs) {
        case (.unknownCommand, .unknownCommand): return true
        case (let .fan(value1), let .fan(value2)): return value1 == value2
        case (let .blower(value1), let .blower(value2)): return value1 == value2
        case (let .led(value1), let .led(value2)): return value1 == value2
        case (let .speaker(value1), let .speaker(value2)): return value1 == value2
        case (let .dumpLoad(value1), let .dumpLoad(value2)): return value1 == value2
        case (let .burnTemperature(value1), let .burnTemperature(value2)): return value1 == value2
        case (let .surfaceTemperature(value1), let .surfaceTemperature(value2)): return value1 == value2
        case (let .pumpTemperature(value1), let .pumpTemperature(value2)): return value1 == value2
        case (let .batteryVoltage(value1), let .batteryVoltage(value2)): return value1 == value2
        case (let .tegVoltage(value1), let .tegVoltage(value2)): return value1 == value2
        case (let .batteryCurrent(value1), let .batteryCurrent(value2)): return value1 == value2
        case (let .tegCurrent(value1), let .tegCurrent(value2)): return value1 == value2
        default: return false
        }
    }
    
    // MARK: - Hashable
    var hashValue: Int {
        return self.string.hashValue
    }
}

private extension String {
    var commandValue: Bool {
        if self == "on" {
            return true
        } else {
            return false
        }
    }
}
