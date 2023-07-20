//
//  UserDefaultsManager.swift
//  Weather-App-iOS
//
//  Created by iPHTech 29 on 27/06/23.
//

import Foundation
import UIKit
class UserDefaultsManager {
    
    //MARK: shared instance
    static let shared = UserDefaultsManager()
    
    let userDefaults = UserDefaults.standard
    
    //MARK: -Public functions
    func addCityName(cityName: String) {
        let userDefaults = UserDefaults.standard
        
        if var cityArrayList = userDefaults.array(forKey: Key.cityArrayList) as? [String] {
            if cityArrayList.contains(cityName) {
                // Data already present, show an alert
                let alertController = UIAlertController(title: "Alert", message: "This data is already present", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                
            } else {
                cityArrayList.append(cityName)
                print(cityArrayList)
                print("cityArrayList = \(cityArrayList.count)")
                userDefaults.set(cityArrayList, forKey: Key.cityArrayList)
            }
        } else {
            // Array not found
            userDefaults.set([cityName], forKey: Key.cityArrayList)
        }
    }
    func getCityNameList() -> [String] {
        guard let cityArrayList = userDefaults.array(forKey: Key.cityArrayList) as? [String] else {
            return [String]()
        }
        return cityArrayList
    }
    
    func isCityDataPresent(cityName: String) -> Bool {
        let cityArray = getCityNameList()
        if cityArray.contains(cityName){
            
            return true
        }
        else {
            return false
        }
    }
    
    func addCityData(cityName: String, data: ForcastWeather){
        do {
            try userDefaults.setObject(data, forKey: cityName)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getCityData(byCityName city: String) -> ForcastWeather?{
        do {
            let cityData = try userDefaults.getObject(forKey: city, castTo: ForcastWeather.self)
            return cityData
        } catch {
            print(error.localizedDescription)
            return nil
        }

    }
    func getAllCityData(cityArray: [String]) -> [ForcastWeather]? {
        var citiesDataArray = [ForcastWeather]()
        for item in cityArray{
            if let cityData = getCityData(byCityName: item){
                citiesDataArray.append(cityData)
            }
        }
        if citiesDataArray.count > 0{
            return citiesDataArray
        }
        return nil
    }
}
