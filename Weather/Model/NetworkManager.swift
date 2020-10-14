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
        
        static let googleMaps: String = "" // Enter your google maps API key here
        
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
        
        /// 无用接口
        static func cityData(for placeID: String) ->  String {
            return "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&key=\(NetworkManager.Key.googleMaps)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
    }
        
}

/// 谷歌的没有用
/*
extension NetworkManager.APIURL {
    /// 谷歌地图通过关键词搜索
    /// - Parameter search: 关键词
    /// - Returns: url拼接后的编码
    static func cityCompletion(for search: String) -> String {
        return "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(search)&types=(cities)&key=\(NetworkManager.Key.googleMaps)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }


    /// 谷歌地图通过placeID进行请求
    /// - Parameter placeID: String
    /// - Returns: url拼接后的编码
    static func cityData(for placeID: String) ->  String {
        return "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&key=\(NetworkManager.Key.googleMaps)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}
*/
