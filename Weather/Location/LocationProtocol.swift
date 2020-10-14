//
//  ILocation.swift
//  JiuRongCarERP
//
//  Created by season on 2018/5/4.
//  Copyright © 2018年 season. All rights reserved.
//

/// 定位结果的回调
protocol LocationDelegate: class {
    func onLocationSuccess(city: City)
    
    func onLocationFail(error: Error?)
}

/// 定位管理器遵守的协议
protocol LocationServiceProtocol {
    var locationDelegate: LocationDelegate? { get set }
    
    func onInitLocationConfig()
    
    func onStartLocation()
    
    func onStopLocation()
}

/// 是否是中国境内
protocol ChinaTerritoryProtocol {
    static func isChinaTerritory(latlngEntity: City) -> Bool
}
