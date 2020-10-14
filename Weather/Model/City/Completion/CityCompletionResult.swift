//
//  CityCompletionResult.swift
//  Weather
//
//  Created by Lunabee on 21/06/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SwiftUI

extension CityCompletion {
    
    struct Result: Codable {
        
        let count : String?
        let geocodes : [Geocode]?
        let info : String?
        let infocode : String?
        let status : String?
        
    }
    
    struct Geocode : Codable, Identifiable {
        var id: String {
            return adcode ?? ""
        }
    
        let adcode : String?
        let city : String?
        let citycode : String?
        let country : String?
        let formattedAddress : String?
        let level : String?
        let location : String?
        let province : String?


        enum CodingKeys: String, CodingKey {
            case adcode = "adcode"
            case city = "city"
            case citycode = "citycode"
            case country = "country"
            case formattedAddress = "formatted_address"
            case level = "level"
            case location = "location"
            case province = "province"

        }
    }
}
