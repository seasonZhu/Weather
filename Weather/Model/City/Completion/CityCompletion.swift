//
//  CityCompletion.swift
//  Weather
//
//  Created by Lunabee on 13/06/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SwiftUI
import Combine

class CityCompletion: ObservableObject {
    
    private var completionManager: CityCompletionManager
        
    @Published var geocodes: [CityCompletion.Geocode] = []
    
    init() {
        geocodes = []
        completionManager = CityCompletionManager()
    }
    
    func search(_ search: String) {
        completionManager.getCompletion(for: search) { (geocodes) in
            DispatchQueue.main.async {
                self.geocodes = geocodes
            }
        }
    }
    
}
