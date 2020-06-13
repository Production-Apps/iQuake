//
//  SettingsTableViewController.swift
//  Quakes
//
//  Created by FGT MAC on 5/16/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import UIKit

protocol SettingsManagementDelegate: class {
    func settingsDidChanged()
}

class SettingsTableViewController: UITableViewController {
    
    //MARK: - Properties
    private let defaults = UserDefaults.standard
    private var settingHasChanged = false
    weak var delegate: SettingsManagementDelegate?
    
    //MARK: - Outlets
    @IBOutlet weak var zoomSileder: UISlider!
    @IBOutlet weak var kmSwitch: UISwitch!
    @IBOutlet weak var locationSwitch: UISwitch!
    

    //MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if settingHasChanged{
            delegate?.settingsDidChanged()
        }
    }
    
    //MARK: - Setup UI
    
    private func updateSettings(){
        kmSwitch.isOn = defaults.bool(forKey: "LightQuakesPref")
        locationSwitch.isOn = defaults.bool(forKey: "LocationPref")
        
        //If use location is disable/enable then disable/enable slider
        zoomSileder.isEnabled = locationSwitch.isOn
        zoomSileder.value = defaults.float(forKey: "LocationZoom") / 10
    }
    
    //MARK: - Actions
    
    @IBAction func lightQuakesTap(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: "LightQuakesPref")
       settingHasChanged=true
    }
    
    @IBAction func zoomSliderMoved(_ sender: UISlider) {
        
        let value = round(sender.value) * 10
        defaults.set(value, forKey: "LocationZoom")
        settingHasChanged=true
    }
    
    @IBAction func locationSwitchTap(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: "LocationPref")
        settingHasChanged = true
        //Disable zoom if use my location is disable
        zoomSileder.isEnabled = sender.isOn
    }
    
    //MARK: - Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DevSegue" {
            guard let devVC = segue.destination as? WebViewController else {
                return
            }
            devVC.urlString =  "https://fritzgt.com"
        }else if segue.identifier == "USGSSegue"{
            guard let usgsVC = segue.destination as? WebViewController else {
                        return
                    }
                    usgsVC.urlString =  "https://www.usgs.gov/about/about-us/who-we-are"
        }else if segue.identifier == "FaqSegue"{
            guard let usgsVC = segue.destination as? WebViewController else {
                        return
                    }
                    usgsVC.urlString =  "https://www.usgs.gov/natural-hazards/earthquake-hazards/faqs-category"
        }else if segue.identifier == "PrepareSegue"{
            guard let usgsVC = segue.destination as? WebViewController else {
                        return
                    }
                    usgsVC.urlString =  "https://www.usgs.gov/natural-hazards/earthquake-hazards/science/prepare?qt-science_center_objects=0#qt-science_center_objects"
        }
        
    }
    
}
