//
//  CityRow.swift
//  Weather
//
//  Created by Lunabee on 13/06/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SwiftUI

struct CityRow : View {
    
    @ObservedObject var city: City
    
    var body: some View {
        NavigationLink(destination: CityWeatherView(city: city)) {
            HStack(alignment: .firstTextBaseline) {
                Text(city.name)
                    .lineLimit(nil)
                    .font(.title)
                Spacer()
                HStack {
                    city.weather?.current.icon.image
                        .foregroundColor(.gray)
                        .font(.title)
                    Text(city.weather?.current.temperature.formattedTemperature ?? "-ºC")
                        .foregroundColor(.gray)
                        .font(.title)
                        .fixedSize()
                }
            }
            .padding([.trailing, .top, .bottom])
        }
    }
    
}
