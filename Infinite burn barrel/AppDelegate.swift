//
//  AppDelegate.swift
//  Infinite burn barrel
//
//  Created by Mohamed Hage on 2018-02-27.
//  Copyright © 2018 Mohamed Hage. All rights reserved.
//

import UIKit
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupLogger()
        return true
    }
    
    // MARK: - Logging
    public let fileLogger: DDFileLogger = DDFileLogger()
    private func setupLogger() {
        DDLog.add(DDTTYLogger.sharedInstance)
        
        // File logger
        fileLogger.rollingFrequency = TimeInterval(60*60*24)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger, with: .info)
    }
}

