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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var statusValueLabel: UILabel!
    @IBOutlet weak var blowerValueLabel: UILabel!
    @IBOutlet weak var combustionTempValueLabel: UILabel!
    @IBOutlet weak var combustionTempSetLabel: UILabel!
    @IBOutlet weak var hotPlateTempValueLabel: UILabel!
    @IBOutlet weak var heatSinkTempValueLabel: UILabel!
    @IBOutlet weak var tegValueLabel: UILabel!
    @IBOutlet weak var batteryValueLabel: UILabel!
    @IBOutlet weak var instantHotWaterSwitch: UISwitch!
    @IBOutlet weak var hotWaterValueLabel: UILabel!
    @IBOutlet weak var hotWaterSetLabel: UILabel!
    @IBOutlet weak var lanternLabel: UILabel!
    @IBOutlet weak var speakerSwitch: UISwitch!
    @IBOutlet weak var listenValueLabel: UILabel!
    @IBOutlet weak var speakTextField: UITextField!
    @IBOutlet weak var footerTextValueLabel: UILabel!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var combustionTempSlider: UISlider!
    @IBOutlet weak var hotWaterSlider: UISlider!
    @IBOutlet weak var lanternSlider: UISlider!
    
    private let barrelController = InfiniteBurnBarrelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setStatus(on: false)
        
        setupBarrelController()
        
        sendInitialCommands()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        barrelController.removeDelegate(self)
    }
    
    private func setupBarrelController() {
        barrelController.addDelegate(self)
    }
    
    // MARK: - UI Setters
    private func setStatus(on: Bool) {
        statusValueLabel.text = on ? "on" : "off"
        statusValueLabel.textColor = on ? .blue : .red
    }
    
    private func setBlower(value: Int) {
        blowerValueLabel.text = "\(value)"
    }
    
    private func setCombustionTemp(value: Int) {
        combustionTempValueLabel.text = formattedString(temperature: value)
    }
    
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
    
    private func setInstantHotWater(on: Bool) {
        instantHotWaterSwitch.setOn(on, animated: true)
    }
    
    private func setHotWaterTemp(value: Int) {
        hotWaterValueLabel.text = formattedString(temperature: value)
    }
    
    private func setDesiredHotWaterTemp(value: Int) {
        hotWaterSetLabel.text = "Set to (\(formattedString(temperature: value))):"
    }
    
    private func setLanternLabel(value: Int) {
        lanternLabel.text = "Lantern (\(value)):"
    }
    
    private func setSpeaker(on: Bool) {
        speakerSwitch.setOn(on, animated: true)
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
    
    fileprivate func updateUI(withReadings readings: InfiniteBurnBarrelReadable) {

        setBlower(value: readings.blower)
        
        DDLogVerbose("Setting temps: \(readings.burnTemperature); \(readings.surfaceTemperature); \(readings.pumpTemperature)")
        setCombustionTemp(value: Int(readings.burnTemperature))
        setHotPlateTemp(value: Int(readings.surfaceTemperature))
        setHotWaterTemp(value: Int(readings.pumpTemperature))
        setHeatSinkTemp(value: Int(readings.heatSinkTemperature))
        
        DDLogVerbose("Setting voltages: Batt - \(readings.batteryVoltage); TEG - \(readings.tegVoltage)")
        DDLogVerbose("Setting currents: Batt - \(readings.batteryCurrent); TEG - \(readings.tegCurrent)")
        setBattery(volts: Double(readings.batteryVoltage), amps: Double(readings.batteryCurrent), watts: abs(Double(readings.batteryVoltage * readings.batteryCurrent)))
        setTEG(volts: Double(readings.tegVoltage), amps: Double(readings.tegCurrent), watts: abs(Double(readings.tegVoltage * readings.tegCurrent)))
        
        clearListenLabel() // TODO: Do you want this label cleared?
        appendToListenLabel(text: readings.listen)
    }
    
    // MARK: - Actions
    @IBAction func onCombustionTempChangedAction() {
        DDLogVerbose("[BarrelVC - Action] Desired combustion temp slider - value: \(combustionTempSlider.value)")
        setDesiredCombustionTemp(value: Int(combustionTempSlider.value))
        
        let command = InfiniteBurnBarrelCommand.desiredBurnTemperature(temperature: combustionTempSlider.value)
        sendCommand(command)
    }
    
    @IBAction func onInstantHotWaterChangedAction() {
        DDLogVerbose("[BarrelVC - Action] Instant hot water switch changed - isOn: \(instantHotWaterSwitch.isOn)")
        
        let command = InfiniteBurnBarrelCommand.instantHotWater(value: (instantHotWaterSwitch.isOn ? 1 : 0))
        sendCommand(command)
    }
    
    @IBAction func onHotWaterTempChangedAction() {
        DDLogVerbose("[BarrelVC - Action] Desired hot water temp slider - value: \(hotWaterSlider.value)")
        
        setDesiredHotWaterTemp(value: Int(hotWaterSlider.value))
        let command = InfiniteBurnBarrelCommand.desiredPumpTemperature(temperature: hotWaterSlider.value)
        sendCommand(command)
    }
    
    @IBAction func onLanternChangedAction() {
        let lanternValue = Int(lanternSlider.value)
        DDLogVerbose("[BarrelVC - Action] Lantern switch changed: \(lanternValue)")
        
        setLanternLabel(value: lanternValue)
        let command = InfiniteBurnBarrelCommand.led(value: lanternValue)
        sendCommand(command)
    }
    
    @IBAction func onSpeakerChangedAction() {
        DDLogVerbose("[BarrelVC - Action] Speaker switch changed - isOn: \(speakerSwitch.isOn)")
        
        let command = InfiniteBurnBarrelCommand.speaker(value: (speakerSwitch.isOn ? 1 : 0))
        sendCommand(command)
    }
    
    // TODO: Use default values on the UI.
    private func sendInitialCommands() {
        onCombustionTempChangedAction()
        onInstantHotWaterChangedAction()
        onHotWaterTempChangedAction()
        onLanternChangedAction()
        onSpeakerChangedAction()
    }
    
    private func sendCommand(_ command: InfiniteBurnBarrelCommand) {
        barrelController.lastReading?.update(withCommand: command)
        barrelController.sendCommand(command)
    }
}

// MARK: - InfiniteBurnBarrelDelegate
extension BarrelViewController: InfiniteBurnBarrelDelegate {
    func infiniteBurnBarrelDidConnect(_ barrel: InfiniteBurnBarrelControllable) {
        setStatus(on: true)
    }
    
    func infiniteBurnBarrelDidDisconnect(_ barrel: InfiniteBurnBarrelControllable) {
        setStatus(on: false)
    }
    
    func infiniteBurnBarrelDidReceiveReadings(_ barrel: InfiniteBurnBarrelControllable, _ readings: InfiniteBurnBarrelReadable) {
        updateUI(withReadings: readings)
    }
}

extension BarrelViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let text = textField.text {
            DDLogVerbose("[BarrelVC - Action] Speak sending text: \(text)")
            
            let command = InfiniteBurnBarrelCommand.custom(text: text)
            barrelController.lastReading?.update(withCommand: command)
            barrelController.sendCommand(command)
        }
        textField.resignFirstResponder()
        
        return true
    }
}

// MARK: Keyboard Handling
extension BarrelViewController
{
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollViewBottomConstraint.constant = -keyboardSize.height
            })
            self.scrollView.scrollRectToVisible(speakTextField.frame, animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.scrollViewBottomConstraint.constant = 0
        }
    }
}
