//
//  Quake.swift
//  Quakes
//
//  Created by FGT MAC on 5/3/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation


class Quake: NSObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case magnitude = "mag"
        case time
        case place
        case latitude
        case longitude
        case depth
        case url
        //Second level
        case properties
        //Third level
        case geometry
        //4th level deep
        case coordinates
    }
    
    let magnitude: Double?
    let time: Date
    let place: String
    let latitude: Double
    let longitude: Double
    let depth: Double
    let url: String
    
    
    required init(from decoder: Decoder) throws {
        //Containers to pull out data
        //Fist level within the JSON
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //Second level inside the first "container"
        let properties = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .properties)
        //3rd level inside the first "properties"
        let geometry = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .geometry)
        //4th level inside the first "geometry"
        var coordinates = try geometry.nestedUnkeyedContainer(forKey: .coordinates)
        
        
        //Extract our properties
        self.magnitude = try? properties.decode(Double.self, forKey: .magnitude)//If nil it wont crash because of the try?
        self.time = try properties.decode(Date.self, forKey: .time)
        self.place = try properties.decode(String.self, forKey: .place)
        self.url = try properties.decode(String.self, forKey: .url)
        
        //In the API Docs shows the following order in the unkey JSON:
        //IF we put latitude first the it wont work
        self.longitude = try coordinates.decode(Double.self)
        self.latitude = try coordinates.decode(Double.self)
        self.depth = try coordinates.decode(Double.self)
        
        
        super.init()
    }
}
