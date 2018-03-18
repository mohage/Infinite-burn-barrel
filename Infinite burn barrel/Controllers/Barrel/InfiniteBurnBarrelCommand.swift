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
}

enum InfiniteBurnBarrelCommand
{
    case unknownCommand
    case fan(on: Bool)
    case blower(value: Int)
    
    var string: String {
        get {
            switch self {
            case .unknownCommand: return "unknown"
            case .fan(let value): return "\(CommandKey.fan.rawValue)_\(value.commandValue)"
            case .blower(let value): return "\(CommandKey.blower.rawValue)_\(value)"
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
            }
        }
        
        return .unknownCommand
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
