//
//  BarrelViewController.swift
//  Infinite burn barrel
//
//  Created by Dejan on 25/03/2018.
//  Copyright © 2018 Mohamed Hage. All rights reserved.
//

import UIKit
import CocoaLumberjack

class BarrelViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var statusValueLabel: UILabel!
    @IBOutlet weak var blowerValueLabel: UILabel!
    @IBOutlet weak var combustionTempValueLabel: UILabel!
    @IBOutlet weak var combustionTempSetLabel: UILabel!
    @IBOutlet weak var hotPlateTempValueLabel: UILabel!
    @IBOutlet weak var heatSinkTempValueLabel: UILabel!
    @IBOutlet weak var tegValueLabel: UILabel!
    @IBOutlet weak var batteryValueLabel: UILabel!
    @IBOutlet weak var dumpLoadValueLabel: UILabel!
    @IBOutlet weak var instantHotWaterSwitch: UISwitch!
    @IBOutlet weak var hotWaterValueLabel: UILabel!
    @IBOutlet weak var hotWaterSetLabel: UILabel!
    @IBOutlet weak var lanternSwitch: UISwitch!
    @IBOutlet weak var speakerSwitch: UISwitch!
    @IBOutlet weak var speakerDiscoverableLabel: UILabel!
    @IBOutlet weak var listenValueLabel: UILabel!
    @IBOutlet weak var speakTextField: UITextField!
    @IBOutlet weak var footerTextValueLabel: UILabel!
    
    private let barrelController = InfiniteBurnBarrelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBarrelController()
    }
    
    deinit {
        barrelController.removeDelegate(self)
    }
    
    private func setupBarrelController() {
        barrelController.addDelegate(self)
    }
    
    // MARK: - UI Setters
    // TODO: Is this supposed to be the blower status? Wouldn't a switch be better?
    private func setStatus(on: Bool) {
        statusValueLabel.text = on ? "on" : "off"
        statusValueLabel.textColor = on ? .blue : .red
    }
    
    private func setBlower(value: Int) {
        blowerValueLabel.text = formattedString(percentage: value)
    }
    
    // Existing combustion temperature. Read from the device.
    private func setCombustionTemp(value: Int) {
        combustionTempValueLabel.text = formattedString(temperature: value)
    }
    
    // Desired combustion temperature.
    private func setDesiredCombustionTemp(value: Int) {
        combustionTempSetLabel.text = "Set to (\(formattedString(temperature: value))):"
    }
    
    private func setHotPlateTemp(value: Int) {
        hotPlateTempValueLabel.text = formattedString(temperature: value)
    }
    
    private func setHeatSinkTemp(value: Int) {
        heatSinkTempValueLabel.text = formattedString(temperature: value)
    }
    
    private func setTEG(volts: Double, amps: Double, watts: Double) {
        tegValueLabel.text = formattedString(volts: volts, amps: amps, watts: watts)
    }
    
    private func setBattery(volts: Double, amps: Double, watts: Double) {
        batteryValueLabel.text = formattedString(volts: volts, amps: amps, watts: watts)
    }
    
    private func setDumpLoad(value: Int) {
        dumpLoadValueLabel.text = formattedString(percentage: value)
    }
    
    private func setInstantHotWater(on: Bool) {
        instantHotWaterSwitch.setOn(on, animated: true)
    }
    
    private func setHotWaterTemp(value: Int) {
        hotWaterSetLabel.text = formattedString(temperature: value)
    }
    
    private func setDesiredHotWaterTemp(value: Int) {
        hotWaterSetLabel.text = "Set to (\(formattedString(temperature: value))):"
    }
    
    private func setLantern(on: Bool) {
        lanternSwitch.setOn(on, animated: true)
    }
    
    private func setSpeaker(on: Bool) {
        speakerSwitch.setOn(on, animated: true)
    }
    
    private func setSpeakerDiscoverable(discoverable: Bool) {
        speakerDiscoverableLabel.text = discoverable ? "Discoverable" : "Not Discoverable"
        speakerDiscoverableLabel.textColor = discoverable ? .blue : .red
    }
    
    private func appendToListenLabel(text: String) {
        listenValueLabel.text = listenValueLabel.text ?? "" + text
    }
    
    private func clearListenLabel() {
        listenValueLabel.text = ""
    }
    
    private func setSpeakText(value: String) {
        speakTextField.text = value
    }
    
    private func setFooterText(value: String) {
        footerTextValueLabel.text = value
    }
    
    // MARK: - String Formatters
    private func formattedString(percentage: Int) -> String {
        return "\(percentage)%"
    }
    
    private func formattedString(temperature: Int) -> String {
        return "\(temperature)F"
    }
    
    private func formattedString(volts: Double, amps: Double, watts: Double) -> String {
        return String(format: "%.1fV, %.1fA, %.1fW", volts, amps, watts)
    }
    
    // TODO: Finish this method when you defined all the properties for the barrel!
    fileprivate func updateUI(withReadings readings: InfiniteBurnBarrelReadable) {
        
        // TODO: This is for testing only
        setHotWaterTemp(value: readings.blower)
//        setInstantHotWater(on: readings.fan)
//        setLantern(on: readings.led)
        
        DDLogVerbose("Setting temps: \(readings.burnTemperature); \(readings.surfaceTemperature); \(readings.pumpTemperature)")
        setCombustionTemp(value: Int(readings.burnTemperature))
        setHotPlateTemp(value: Int(readings.surfaceTemperature))
        setHeatSinkTemp(value: Int(readings.pumpTemperature))
        
        DDLogVerbose("Setting voltages: Batt - \(readings.batteryVoltage); TEG - \(readings.tegVoltage)")
        DDLogVerbose("Setting currents: Batt - \(readings.batteryCurrent); TEG - \(readings.tegCurrent)")
        setBattery(volts: Double(readings.batteryVoltage), amps: Double(readings.batteryCurrent), watts: 0.0)
        setTEG(volts: Double(readings.tegVoltage), amps: Double(readings.tegCurrent), watts: 0.0)
    }
    
    // MARK: - Actions
    // TODO: Change min/max values in the storyboard!
    @IBAction func onCombustionTempChangedAction(_ sender: UISlider) {
        DDLogVerbose("[BarrelVC - Action] Desired combustion temp slider - value: \(sender.value)")
        setDesiredCombustionTemp(value: Int(sender.value))
    }
    
    @IBAction func onInstantHotWaterChangedAction(_ sender: UISwitch) {
        DDLogVerbose("[BarrelVC - Action] Instant hot water switch changed - isOn: \(sender.isOn)")
        
        // TODO: This is for demo only, replace with real values once you have them
//        if var newReadings = barrelController.lastReading {
//            newReadings.fan = sender.isOn
//            barrelController.sendReadings(newReadings)
//        }
    }
    
    // TODO: Change min/max values in the storyboard!
    @IBAction func onHotWaterTempChangedAction(_ sender: UISlider) {
        DDLogVerbose("[BarrelVC - Action] Desired hot water temp slider - value: \(sender.value)")
        setDesiredHotWaterTemp(value: Int(sender.value))
        
        // TODO: This is for demo only, replace with real values once you have them
//        if var newReadings = barrelController.lastReading {
//            newReadings.blower = Int(sender.value)
//            barrelController.sendReadings(newReadings)
//        }
    }
    
    @IBAction func onLanternChangedAction(_ sender: UISwitch) {
        DDLogVerbose("[BarrelVC - Action] Lantern switch changed - isOn: \(sender.isOn)")
        
        barrelController.lastReading?.update(withCommand: .fan(value: (sender.isOn ? 1 : 0)))
        
        if var newReadings = barrelController.lastReading {
            //newReadings.led = sender.isOn
            barrelController.sendReadings(newReadings)
        }
    }
    
    @IBAction func onSpeakerChangedAction(_ sender: UISwitch) {
        DDLogVerbose("[BarrelVC - Action] Speaker switch changed - isOn: \(sender.isOn)")
    }
}

// MARK: - InfiniteBurnBarrelDelegate
extension BarrelViewController: InfiniteBurnBarrelDelegate {
    func infiniteBurnBarrelDidConnect(_ barrel: InfiniteBurnBarrelControllable) {
        // TODO: Do you want to display something on the UI if the barrel connects?
        // You have the status label at the top
    }
    
    func infiniteBurnBarrelDidDisconnect(_ barrel: InfiniteBurnBarrelControllable) {
        // TODO: Do you want to display something on the UI if the barrel disconnects?
        // You have the status label at the top
    }
    
    func infiniteBurnBarrelDidReceiveReadings(_ barrel: InfiniteBurnBarrelControllable, _ readings: InfiniteBurnBarrelReadable) {
        updateUI(withReadings: readings)
    }
}
