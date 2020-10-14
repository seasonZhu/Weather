//
//  SceneDelegate.swift
//  Weather
//
//  Created by Lunabee on 12/06/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    let cityDatasKey = "cityDatasKey"

    var window: UIWindow?
    
    let cityStore = CityStore()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        readData()
        
        LocationManager.appleInstance.setLocationDelegate(self).startLocation()
        
        let window = UIWindow(windowScene: windowScene)
        
        window.rootViewController = UIHostingController(rootView: CityListView().environmentObject(cityStore))
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        /// 程序退出 保存数据
        saveData()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate: LocationDelegate {
    func onLocationSuccess(city: City) {
        if cityStore.cities.contains(where: { (cityInArray) -> Bool in
            city.name == cityInArray.name
        }) {
            return
        }
        cityStore.cities.insert(city, at: 0)
    }
    
    func onLocationFail(error: Error?) {
        cityStore.cities.append(City.wuhan())
    }
}

extension SceneDelegate {
    func saveData() {
        let cityDatas: [Data] = cityStore.cities.compactMap { try? JSONEncoder().encode(CityInSandBox(name: $0.name, longitude: $0.longitude, latitude: $0.latitude)) }
        UserDefaults.standard.set(cityDatas, forKey: cityDatasKey)
    }
    
    func readData() {
        let value = UserDefaults.standard.value(forKey: cityDatasKey)
        if let cityDatas = value as? [Data] {
            let citys = cityDatas
                .compactMap { try? JSONDecoder().decode(CityInSandBox.self, from: $0) }
                .compactMap { City(name: $0.name, longitude: $0.longitude, latitude: $0.latitude) }
            cityStore.cities.append(contentsOf: citys)
        }
    }
}
