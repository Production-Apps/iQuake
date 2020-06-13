//
//  SettingsTableViewController.swift
//  Quakes
//
//  Created by FGT MAC on 5/16/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    
    //MARK: - Properties
    private let defaults = UserDefaults.standard
    
    
    //MARK: - Outlets
    @IBOutlet weak var zoomSileder: UISlider!
    @IBOutlet weak var kmSwitch: UISwitch!
    @IBOutlet weak var locationSwitch: UISwitch!
    

    //MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSettings()
    }
    
    //MARK: - Setup UI
    
    private func updateSettings(){
        kmSwitch.isOn = defaults.bool(forKey: "LightQuakesPref")
        zoomSileder.value = defaults.float(forKey: "LocationZoom") / 10
        locationSwitch.isOn = defaults.bool(forKey: "LocationPref")
    }
    
    //MARK: - Actions
    
    @IBAction func lightQuakesTap(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: "LightQuakesPref")
    }
    
    @IBAction func zoomSliderMoved(_ sender: UISlider) {
        
        let value = round(sender.value) * 10
        
        defaults.set(value, forKey: "LocationZoom")
    }
    
    @IBAction func locationSwitchTap(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: "LocationPref")
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
