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
    case burnTemperature = "btemp"
    case surfaceTemperature = "stemp"
    case pumpTemperature = "ptemp"
}

enum InfiniteBurnBarrelCommand: Equatable, Hashable
{
    case unknownCommand
    case fan(on: Bool)
    case blower(value: Int)
    case led(on: Bool)
    case burnTemperature(temperature: Float)
    case surfaceTemperature(temperature: Float)
    case pumpTemperature(temperature: Float)
    
    
    var string: String {
        get {
            switch self {
            case .unknownCommand: return "unknown"
            case .fan(let value): return "\(CommandKey.fan.rawValue)_\(value.commandValue)"
            case .blower(let value): return "\(CommandKey.blower.rawValue)_\(value)"
            case .led(let value): return "\(CommandKey.led.rawValue)_\(value.commandValue)"
            case .burnTemperature(let value): return "\(CommandKey.burnTemperature.rawValue)_\(value)"
            case .surfaceTemperature(let value): return "\(CommandKey.surfaceTemperature.rawValue)_\(value)"
            case .pumpTemperature(let value): return "\(CommandKey.pumpTemperature.rawValue)_\(value)"
            }
        }
    }
    
    static func command(fromString string: String) -> InfiniteBurnBarrelCommand
    {
        let keyValue = string.split(separator: "_")
        
        if let key = keyValue.first {
            if key == CommandKey.fan.rawValue, let value = keyValue.last {
                return .fan(on: String(value).commandValue)
            } else if key == CommandKey.blower.rawValue, let value = keyValue.last, let intValue = Int(value) {
                return .blower(value: intValue)
            } else if key == CommandKey.led.rawValue, let value = keyValue.last {
                return .led(on: String(value).commandValue)
            } else if key == CommandKey.burnTemperature.rawValue, let value = keyValue.last {
                return .burnTemperature(temperature: Float(value) ?? 0.0)
            } else if key == CommandKey.surfaceTemperature.rawValue, let value = keyValue.last {
                return .surfaceTemperature(temperature: Float(value) ?? 0.0)
            } else if key == CommandKey.pumpTemperature.rawValue, let value = keyValue.last {
                return .pumpTemperature(temperature: Float(value) ?? 0.0)
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
        case (let .burnTemperature(value1), let .burnTemperature(value2)): return value1 == value2
        case (let .surfaceTemperature(value1), let .surfaceTemperature(value2)): return value1 == value2
        case (let .pumpTemperature(value1), let .pumpTemperature(value2)): return value1 == value2
        default: return false
        }
    }
    
    // MARK: - Hashable
    var hashValue: Int {
        return self.string.hashValue
    }
}

private extension Bool {
    var commandValue: String {
        return self ? "on" : "off"
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
