//
//  LaunchViewController.swift
//  Infinite burn barrel
//
//  Created by Dejan on 24/06/2018.
//  Copyright © 2018 Mohamed Hage. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    private enum LaunchConstants {
        static let BarrelVC = "BarrelVC"
        static let LaunchDelay = 3.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + LaunchConstants.LaunchDelay) {
            self.presentHomeVC()
        }
    }
    
    private func presentHomeVC() {
        if let barrelVC = storyboard?.instantiateViewController(withIdentifier: LaunchConstants.BarrelVC) {
            barrelVC.modalTransitionStyle = .crossDissolve
            present(barrelVC, animated: true, completion: nil)
        }
    }
}
