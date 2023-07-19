//
//  Constants.swift
//  Weather-App-iOS
//
//  Created by iPHTech 29 on 27/06/23.
//

import Foundation
import UIKit
          
//constants
let defaults = UserDefaults.standard

struct Key {
   static let cityArrayList: String = "CityArrayList"
    static var viewWillAppear = true
}

struct ColorConstant {
    static let partlyCloudyBottom =  UIColor(red: 81.0/255.0, green: 185.0/255.0, blue: 226.0/255.0, alpha: 1.0)
    static let partlyCloudyTop = UIColor(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
    static let sunnyTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let sunnyBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0)
    static let cloudyBottom =  UIColor(red: 156.0/255.0, green: 187.0/255.0, blue: 202.0/255.0, alpha: 1.0)
    static let cloudyTop = UIColor(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
    static let otherTop =  UIColor(red: 212.0/255.0, green: 66.0/255.0, blue: 226.0/255.0, alpha: 1.0)
    static let otherBottom = UIColor(red: 68.0/255.0, green: 71.0/255.0, blue: 237.0/255.0, alpha: 1.0)
}
