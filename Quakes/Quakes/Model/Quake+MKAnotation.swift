//
//  Quake+MKAnotation.swift
//  Quakes
//
//  Created by FGT MAC on 5/3/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import MapKit

extension Quake: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        //Each coordinate from quakes will be pass to this
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude )
    }
    

    var title: String? {
        place
    }
    
    var subtitle: String? {
        if let magnitude = magnitude {
            return "Magnitude: \(magnitude)"
        }else{
            return "Magnitude: N/A"
        }
    }
}

