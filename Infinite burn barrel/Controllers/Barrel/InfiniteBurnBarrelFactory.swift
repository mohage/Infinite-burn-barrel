//
//  InfiniteBurnBarrelFactory.swift
//  Infinite burn barrel
//
//  Created by Dejan on 18/03/2018.
//  Copyright © 2018 Mohamed Hage. All rights reserved.
//

import Foundation

protocol InfiniteBurnBarrelFactoryProtocol {
    func fromString(_ string: String) -> InfiniteBurnBarrelReadable?
    func toString(_ readings: InfiniteBurnBarrelReadable) -> String?
}

class InfiniteBurnBarrelFactory: InfiniteBurnBarrelFactoryProtocol
{
    func fromString(_ string: String) -> InfiniteBurnBarrelReadable? {
        return nil
    }
    
    func toString(_ readings: InfiniteBurnBarrelReadable) -> String? {
        return nil
    }
}

class InfiniteBurnBarrelReadings: InfiniteBurnBarrelReadable {
    // TODO: Add properties
}
