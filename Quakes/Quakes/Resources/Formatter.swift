//
//  Formatter.swift
//  Quakes
//
//  Created by FGT MAC on 5/8/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation

struct Formatter {
    
     lazy var dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .short
        result.timeStyle = .short
        return result
    }()
    
     lazy var latLonFormatter: NumberFormatter = {
         let result = NumberFormatter()
         result.numberStyle = .decimal
         result.minimumIntegerDigits = 1
         result.minimumFractionDigits = 2
         result.maximumFractionDigits = 2
         return result
     }()
}
