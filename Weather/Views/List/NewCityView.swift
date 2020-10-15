//
//  NewCityView.swift
//  Weather
//
//  Created by Lunabee on 13/06/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SwiftUI

struct NewCityView : View {
    
    @State private var search: String = ""
    @State private var isValidating: Bool = false
    @ObservedObject private var completer: CityCompletion = CityCompletion()
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var cityStore: CityStore
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Search City", text: $search, onCommit:  {
                        self.completer.search(self.search)
                    }).keyboardType(.default)
                }
                
                Section {
                    ForEach(completer.geocodes) { geocode in
                        Button(action: {
                            self.addCity(from: geocode)
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text(geocode.city ?? "")
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
                .disabled(isValidating)
                .navigationBarTitle(Text("Add City"))
                .navigationBarItems(leading: cancelButton)
                .listStyle(GroupedListStyle())
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel")
        }
    }
    
    private func addCity(from geocode: CityCompletion.Geocode) {
        isValidating = true
        guard let name = geocode.city, let location = geocode.location else {
            self.cityStore.cities.append(City.wuhan())
            self.presentationMode.wrappedValue.dismiss()
            isValidating = false
            return
        }
        
        let array = location.components(separatedBy: ",")
        guard array.count == 2, let longitude = Double(array[0]), let latitude = Double(array[1]) else {
            self.cityStore.cities.append(City.wuhan())
            self.presentationMode.wrappedValue.dismiss()
            isValidating = false
            return
        }
        
        if cityStore.cities.contains(where: { (cityInArray) -> Bool in
            name == cityInArray.name
        }) {
            // 如何toast?
            print("存储列表中已包含该城市")
            isValidating = false
            return
        }
        
        let city = City(name: name, longitude: longitude, latitude: latitude)
        self.cityStore.cities.append(city)
        self.presentationMode.wrappedValue.dismiss()
        
        isValidating = false
    }
    
}
