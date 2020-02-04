//
//  CityWeatherView.swift
//  Weather
//
//  Created by Lunabee on 12/06/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SwiftUI

struct CityWeatherView : View {
    
    @ObservedObject var city: City
    
    var body: some View {
        List {
            Section(header: Text("Now")) {
                CityHeaderView(city: city)
            }

            Section(header: Text("Hourly")) {
                CityHourlyView(city: city)
            }

            Section(header: Text("This week")) {
                ForEach(city.weather?.week.list ?? []) { day in
                    CityDailyView(day: day)
                }
            }
            
            ForEach(0..<10) { (index) in
                Section(header: Text("\(index)")
                    .foregroundColor(.orange)
                    .font(.system(.body))
                ) {
                    Text("\(index * 10)")
                }
            }
        }
        .navigationBarTitle(Text(city.name))
    }
    
}

//#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        CityWeatherView()
//    }
//}
//#endif
