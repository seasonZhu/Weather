//
//  NetworkManager.swift
//  Weather
//
//  Created by Lunabee on 21/06/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import UIKit

class NetworkManager {
    
    struct Key {
        
        static let darkSky: String = "68dbaef8a2b953c7299974b13785426b" // Enter your darkSky API key here
        
        static let gaodeMaps = "732f0e087cd61798322e7b0669117111" // 输入你的高德地图 API key
        
    }
    
    struct APIURL {
        
        /// 通过经纬度获请求天气
        /// - Parameters:
        ///   - longitude: 经度
        ///   - latitude: 纬度
        /// - Returns: url拼接后的编码
        static func weatherRequest(longitude: Double, latitude: Double) -> String {
            return "https://api.darksky.net/forecast/\(NetworkManager.Key.darkSky)/\(latitude),\(longitude)?units=ca&lang=fr".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        
        static func cityCompletion(for search: String) -> String {
            return "https://restapi.amap.com/v3/geocode/geo?key=\(NetworkManager.Key.gaodeMaps)&address=\(search)&city=".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
    }
        
}
