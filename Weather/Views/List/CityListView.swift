//
//  CityListView.swift
//  Weather
//
//  Created by Lunabee on 13/06/2019.
//  Copyright © 2019 Snopia. All rights reserved.
//

import SwiftUI

struct CityListView : View {
    
    /// 全局的修饰器  跨组件快速访问全局数据源
    @EnvironmentObject var cityStore: CityStore
    
    /// 这个使用binding是否有present @State用途就是用来修饰属性,以保证该属性是可以被改变了
    @State var isPresentingModal: Bool = false
    
    /// 这个没有使用
    @State private var isEditing: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Your Cities")) {
                    ForEach(cityStore.cities, id: \.name) { city in
                        CityRow(city: city)
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                }
            }
            .navigationBarItems(leading: EditButton(), trailing: addButton)
            .navigationBarTitle(Text("Weather"))
        }
    }
    
    private var addButton: some View {
        Button(action: {
            self.isPresentingModal = true
        }) {
            Image(systemName: "plus.circle.fill")
            .font(.title)
        }.sheet(isPresented: $isPresentingModal) {
            NewCityView().environmentObject(self.cityStore)
        }
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            cityStore.cities.remove(at: index)
        }
    }

    private func move(from source: IndexSet, to destination: Int) {
        var removeCities: [City] = []
        
        for index in source {
            removeCities.append(cityStore.cities[index])
            cityStore.cities.remove(at: index)
        }
        
        cityStore.cities.insert(contentsOf: removeCities, at: destination)
    }
    
}

//#if DEBUG
//struct CityListView_Previews : PreviewProvider {
//    static var previews: some View {
//        CityListView()
//    }
//}
//#endif
