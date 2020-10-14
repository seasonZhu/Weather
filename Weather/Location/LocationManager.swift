//
//  LocationManager.swift
//  JiuRongCarERP
//
//  Created by season on 2018/5/4.
//  Copyright © 2018年 season. All rights reserved.
//

import Foundation
import CoreLocation

/// 定位权限变更回调
typealias LocationAuthorChanged = (_ locationManager: LocationManager, _ hashasLocationAuthor: Bool) -> ()

/// 定位管理器
class LocationManager {
    //MARK: 属性设置
    
    //  定位超时时间
    static let kLocationTimeout = 10
    //  获取地址信息超时时间
    static let kReGeocodeTimeout = 10
    //  是否有定位权限
    static var hasLocationPermission = false
    
    //  单例
    static let appleInstance = LocationManager()
    
    //  具体的定位服务商
    private var locationService: LocationServiceProtocol

    //  定位成功回调
    private var locationSuccessCallback: ((City) -> Void)?
    
    //  定位失败回调
    private var locationFailureCallback: ((Error?) -> Void)?
    
    //  定位结果的代理
    private weak var locationDelegate: LocationDelegate?
    
    //MARK: 初始化
    private init() {
        locationService = LocationApple()
        
        locationService.onInitLocationConfig()
        locationService.locationDelegate = self
    }
    
    //MARK: 链式方法
    
    /// 设置代理
    ///
    /// - Parameter locationDelegate: 代理
    /// - Returns: 对象本身
    @discardableResult
    func setLocationDelegate(_ locationDelegate: LocationDelegate) -> Self {
        self.locationDelegate = locationDelegate
        return self
    }
    
    /// 设置权限变化 仅对系统定位起作用
    ///
    /// - Parameter locationAuthorChanged: 权限变化闭包
    /// - Returns: 对象本身
    @discardableResult
    func setAuthorChangedListener(_ locationAuthorChanged: @escaping LocationAuthorChanged) -> Self {
        if let service = locationService as? LocationApple {
           service.locationAuthorChanged = locationAuthorChanged
        }
        return self
    }
    
    /// 定位成功的回调
    ///
    /// - Parameter locationSuccessCallback: 定位成功的回调
    /// - Returns: 对象本身
    @discardableResult
    func onLocationSuccessCallback(_ locationSuccessCallback: @escaping (City) -> Void) -> Self {
        self.locationSuccessCallback = locationSuccessCallback
        return self
    }
    
    /// 定位失败的回调
    ///
    /// - Parameter locationFailureCallback: 定位失败的回调
    /// - Returns: 对象本身
    @discardableResult
    func onLocationFailureCallback(_ locationFailureCallback: @escaping (Error?) -> Void) -> Self {
        self.locationFailureCallback = locationFailureCallback
        return self
    }
    
    //MARK: 开始定位
    func startLocation(){
        locationService.onStartLocation()
    }
    
    //MARK: 结束定位
    func stopLocation() {
        locationService.onStopLocation()
        locationService.locationDelegate = nil
    }
}

extension LocationManager: LocationDelegate {
    func onLocationSuccess(city: City) {
        if locationDelegate == nil {
            stopLocation()
        }
        //  代理还是回调随意选择
        locationDelegate?.onLocationSuccess(city: city)
        locationSuccessCallback?(city)
    }
    
    func onLocationFail(error: Error?) {
        //  代理还是回调随意选择
        locationDelegate?.onLocationFail(error: error)
        locationFailureCallback?(error)
    }
}
