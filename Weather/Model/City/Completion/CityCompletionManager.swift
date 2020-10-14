//
//  CityCompletionManager.swift
//  Weather
//
//  Created by Lunabee on 21/06/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import UIKit

class CityCompletionManager {
    
    var completionTask: URLSessionDataTask?
    
    func getCompletion(for search: String, _ completion: @escaping (_ results: [CityCompletion.Geocode]) -> Void) {
        guard let url = URL(string: NetworkManager.APIURL.cityCompletion(for: search)) else {
            completion([])
            return
        }
        
        completionTask?.cancel()
        
        completionTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(CityCompletion.Result.self, from: data)
                guard let geocodes = result.geocodes else {
                    completion([])
                    return
                }
                completion(geocodes)
            } catch {
                print(error.localizedDescription)
                completion([])
            }
        }
        
        completionTask?.resume()
    }
    
}
