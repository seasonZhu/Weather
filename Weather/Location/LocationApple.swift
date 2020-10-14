//
//  LocationApple.swift
//  JiuRongCarERP
//
//  Created by season on 2018/5/4.
//  Copyright © 2018年 season. All rights reserved.
//

import UIKit
import CoreLocation

class LocationApple: NSObject, LocationServiceProtocol {
    
    //MARK:- 属性设置
    weak var locationDelegate: LocationDelegate?
    
    //  定位权限变化的回调
    var locationAuthorChanged: LocationAuthorChanged?
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    //MARK:- LocationServiceProtocol
    func onInitLocationConfig() {
        //kCLLocationAccuracyBestForNavigation // 最适合导航
        //kCLLocationAccuracyBest; // 最好的
        //kCLLocationAccuracyNearestTenMeters; // 附近10米
        //kCLLocationAccuracyHundredMeters; // 100米
        //kCLLocationAccuracyKilometer; // 1000米
        //kCLLocationAccuracyThreeKilometers; // 3000米
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
            locationManager.requestWhenInUseAuthorization()
        }
        
    }
    
    func onStartLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func onStopLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationApple: CLLocationManagerDelegate {
    /// 定位服务权限改变
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        //  用户还未决定授权
        case .notDetermined:
            print("用户未决定")
            locationAuthorChanged?(LocationManager.appleInstance, false)
        //  访问受限
        case .restricted:
            print("受限制")
            locationAuthorChanged?(LocationManager.appleInstance, false)
        //  拒绝
        case .denied:
            if CLLocationManager.locationServicesEnabled() {
                showAlertViewController()
            }else {
                print("硬件不支持")
            }
            locationAuthorChanged?(LocationManager.appleInstance, false)
        //  定位可用
        case .authorizedAlways,.authorizedWhenInUse:
            print("定位可以使用")
            locationAuthorChanged?(LocationManager.appleInstance, true)
        @unknown default:
            break
        }
    }
    
    /// 苹果定位成功
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        
        //  调用回调
        if let location = locations.first {
            let coordinate = location.coordinate
            print(String.init(format: "经度:%3.5f\n纬度:%3.5f", coordinate.latitude, coordinate.longitude))
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    self.locationDelegate?.onLocationFail(error: error)
                    return
                }
                
                guard let place = placemarks?.first else {
                    self.locationDelegate?.onLocationFail(error: error)
                    return
                }
                
                let city = City(name: place.locality ?? "", longitude: coordinate.longitude, latitude: coordinate.latitude)
                self.locationDelegate?.onLocationSuccess(city: city)
            }
        }
        
    }
    
    /// 苹果定位失败
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
}

extension LocationApple {
    /// 无权限的弹窗
    private func showAlertViewController() {
        
        let appName = (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? ""
        let message = "\"\(appName)\"没有位置访问权限，请前往\"设置-隐私-位置\"选项中，允许访问位置!"
        
        let alertController: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let actionCancel: UIAlertAction = UIAlertAction(title: "取消", style: .default) { (UIAlertAction) in
            
        }
        let actionOK: UIAlertAction = UIAlertAction(title: "设置", style: .default) { (UIAlertAction) in
            guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else {
                return
            }
            
            UIApplication.shared.openURL(url)
        }
        alertController.addAction(actionCancel)
        alertController.addAction(actionOK)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
