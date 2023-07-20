//
//  APIConst.swift
//  Weather-App-iOS
//
//  Created by iPHTech 23 on 19/07/23.
//

import Foundation

//4f7f92e0c2a54381b3a165050231907

//"https://api.weatherapi.com/v1/forecast.json?key=20cbed94eb3249a8896170136232705&q=lucknow&days=1"

struct APIUrlString {
    static let API_KEY = "20cbed94eb3249a8896170136232705"
    static let forcast_base_url = "https://api.weatherapi.com/v1/forecast.json?"
    
    static func getForcastAPIURLString(query: String, days: Int) -> String{
        return "\(APIUrlString.forcast_base_url)key=\(APIUrlString.API_KEY)&q=\(query)&days=\(days)"
    }
}


