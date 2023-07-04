//
//  UserDefaultsManager.swift
//  Weather-App-iOS
//
//  Created by iPHTech 29 on 27/06/23.
//

import Foundation

class UserDefaultsManager {
    //MARK: shared instance
    static let shared = UserDefaultsManager()
    
    let userDefaults = UserDefaults.standard
    
    //MARK: -Public functions
    func addCityName(cityName: String){
        //save city name key array
        if var cityArrayList = userDefaults.array(forKey: Key.cityArrayList) as? [String] {
                if !cityArrayList.contains(cityName){
                    //add city name
                    cityArrayList.append(cityName)
                    print(cityArrayList)
                    print("cityArrayList = \(cityArrayList.count)")
                   
                   

                    userDefaults.set(cityArrayList, forKey: Key.cityArrayList)
               }
            
        }
        else {
            //array not found
            userDefaults.set([cityName], forKey: Key.cityArrayList)
        }
    }
    
//    func saveAPIValue(apiWeatherValue: String) {
//        if let encoded = try? JSONEncoder().encode(apiWeatherValue) {
//            userDefaults.set(encoded, forKey: Key.cityArrayList)
//        }
//    }
    func getCityNameList() -> [String] {
        guard let cityArrayList = userDefaults.array(forKey: Key.cityArrayList) as? [String] else {
            return [String]()
        }
        return cityArrayList
    }
}
