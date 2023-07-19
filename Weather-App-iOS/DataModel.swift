//
//  DataModel.swift
//  Weather-App-iOS
//
//  Created by iPHTech 29 on 06/06/23.
//

import Foundation

struct WeatherList: Codable  {
    var weather: String
    var country: String
    var region: String
    var city: String
    var temprature: String
    var image: String
    var uvIndex:String
    var sunrise: String
    var sunset: String
    var date: String
    var humidity: String
    var windKph: String
    
    static func defaultWeatherList() -> [WeatherList] {
        
        var friendList = [WeatherList]()
        friendList.append(WeatherList(weather: "cloudy", country: "India", region: "India",city: "", temprature: "34", image: " ",uvIndex: "AAA", sunrise: "BBB", sunset: "cloud", date: "7894561234",humidity: "AAA", windKph: "BBB"))
    
        return friendList
    }
    
    
}
