//
//  SettingsTableViewController.swift
//  Quakes
//
//  Created by FGT MAC on 5/16/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 2 && row == 0 {
            print("Dev website")
        }else if section == 2 && row == 1 {
            print("Powered by USGS")
        }
    }
    
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
        }
    }
    

}
