//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by season on 2020/10/15.
//  Copyright © 2020 Snopia. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct WeatherWidgetEntryView : View {
    var entry: Provider.Entry
    
    let cityDatasKey = "cityDatasKey"
    
    // 尺寸环境变量
    @Environment(\.widgetFamily)
    var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            // 小尺寸
            Text(entry.date, style: .time)
        case .systemMedium:
            // 中尺寸
            Text(entry.date, style: .time)
        case .systemLarge:
            // 大尺寸
            VStack {
                Link(destination: URL(string: "sheme://main")!) {
                    Text("主页")
                }
                    
                Link(destination: URL(string: "sheme://setting")!) {
                    Text("设置")
                }
                
                Text(entry.date, style: .time)
                Text(readData())
            }.widgetURL(URL(string: "sheme://weather")!)
            
        @unknown default:
            fatalError()
        }
    }
}

@main
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather Widget")
        .description("This is a weather widget.")
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension WeatherWidgetEntryView {
    func readData() -> String {
        let groupKey = "group.com.widgetDataShare"
        let appGroup = UserDefaults(suiteName: groupKey)
        let value = appGroup?.object(forKey: cityDatasKey + groupKey)
        if let cityDatas = value as? [Data] {
            let citys = cityDatas
                .compactMap { try? JSONDecoder().decode(CityInSandBox.self, from: $0) }
                .compactMap { City(name: $0.name, longitude: $0.longitude, latitude: $0.latitude) }
            if let city = citys.first {
                return city.name
            }
        }
        return "null"
    }
}

class City: ObservableObject {
        
    var name: String
    var longitude: Double
    var latitude: Double
    
    @Published var image: UIImage?
    @Published var weather: Weather?
    
    init(name: String, longitude: Double, latitude: Double) {
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
        self.image = nil
        self.weather = nil
        self.getWeather()
    }

    static func wuhan() -> City {
        let wuhan = City(name: "武汉", longitude: 114.30, latitude: 30.60)
        return wuhan
    }

    private func getWeather() {
        WeatherManager.getWeather(for: self) { (weather) in
            DispatchQueue.main.async {
                self.weather = weather
            }
        }
    }
    
}

struct CityInSandBox: Codable {
    let name: String
    let longitude: Double
    let latitude: Double
    
    init(name: String, longitude: Double, latitude: Double) {
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }
}

class WeatherManager {
    
    static func getWeather(for city: City, _ completion: @escaping (_ weather: Weather?) -> Void) {
        guard let url = URL(string: NetworkManager.APIURL.weatherRequest(longitude: city.longitude, latitude: city.latitude)) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                let weatherObject = try decoder.decode(Weather.self, from: data)
                completion(weatherObject)
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
    
}

struct Weather: Codable {
    
    var current: HourlyWeather
    var hours: Weather.List<HourlyWeather>
    var week: Weather.List<DailyWeather>
    
    enum CodingKeys: String, CodingKey {
        
        case current = "currently"
        case hours = "hourly"
        case week = "daily"
        
    }
    
}

extension Weather {
    
    struct List<T: Codable & Identifiable>: Codable {
        
        var list: [T]
        
        enum CodingKeys: String, CodingKey {
            
            case list = "data"
            
        }
        
    }
    
}

extension Weather {
    
    enum Icon: String, Codable {
        
        case clearDay = "clear-day"
        case clearNight = "clear-night"
        case rain = "rain"
        case snow = "snow"
        case sleet = "sleet"
        case wind = "wind"
        case fog = "fog"
        case cloudy = "cloudy"
        case partyCloudyDay = "partly-cloudy-day"
        case partyCloudyNight = "partly-cloudy-night"
        
        var image: Image {
            switch self {
            case .clearDay:
                return Image(systemName: "sun.max.fill")
            case .clearNight:
                return Image(systemName: "moon.stars.fill")
            case .rain:
                return Image(systemName: "cloud.rain.fill")
            case .snow:
                return Image(systemName: "snow")
            case .sleet:
                return Image(systemName: "cloud.sleet.fill")
            case .wind:
                return Image(systemName: "wind")
            case .fog:
                return Image(systemName: "cloud.fog.fill")
            case .cloudy:
                return Image(systemName: "cloud.fill")
            case .partyCloudyDay:
                return Image(systemName: "cloud.sun.fill")
            case .partyCloudyNight:
                return Image(systemName: "cloud.moon.fill")
            }
        }
                
    }
    
}


struct DailyWeather: Codable, Identifiable {
    
    var id: Date {
        return time
    }
    
    var time: Date
    var maxTemperature: Double
    var minTemperature: Double
    var icon: Weather.Icon
    
    enum CodingKeys: String, CodingKey {
        
        case time = "time"
        case maxTemperature = "temperatureHigh"
        case minTemperature = "temperatureLow"
        case icon = "icon"
        
    }
    
}

struct HourlyWeather: Codable, Identifiable {
    
    var id: Date {
        return time
    }
    
    var time: Date
    var temperature: Double
    var icon: Weather.Icon
    
}


class NetworkManager {
    
    struct Key {
        
        static let darkSky: String = "68dbaef8a2b953c7299974b13785426b" // Enter your darkSky API key here
        
        static let gaodeMaps = "732f0e087cd61798322e7b0669117111" // 输入你的高德地图 API key
        
    }
    
    struct APIURL {
        
        /// 通过经纬度获请求天气
        /// - Parameters:
        ///   - longitude: 经度
        ///   - latitude: 纬度
        /// - Returns: url拼接后的编码
        static func weatherRequest(longitude: Double, latitude: Double) -> String {
            return "https://api.darksky.net/forecast/\(NetworkManager.Key.darkSky)/\(latitude),\(longitude)?units=ca&lang=fr".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        
        static func cityCompletion(for search: String) -> String {
            return "https://restapi.amap.com/v3/geocode/geo?key=\(NetworkManager.Key.gaodeMaps)&address=\(search)&city=".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
    }
        
}
