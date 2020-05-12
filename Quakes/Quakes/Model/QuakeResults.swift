//
//  QuakeResults.swift
//  Quakes
//
//  Created by FGT MAC on 5/3/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation

class QuakeResults: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case quakes = "features"
    }
    
    let quakes: [Quake]
}
