//
//  WeatherAppCollectionViewswift
//  Weather-App-iOS
//
//  Created by iPHTech 29 on 01/06/23.
//

import UIKit

enum WeatherCategory: String {
    case partlyCloudy = "Partly cloudy"
    case sunny = "Sunny"
    case cloudy = "Cloudy"
}

class WeatherAppCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var weatherLbl: UILabel!
    @IBOutlet weak var tempratureLbl: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var regionLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    
    
    private func setupBackground(topColor: UIColor, bottomColor: UIColor) {
        let gradientLayer = craeteGredientColor(rect: mainView.bounds,topColor: topColor, bottomColor: bottomColor)
        mainView.layer.insertSublayer(gradientLayer, at:0)
        
        let curvedRect = CGMutablePath().createCurvedRectangle(width: mainView.bounds.width, height: mainView.bounds.height)
        
        let maskLayer = CAShapeLayer().addCurvedLayer(curvedRect: curvedRect)
        mainView.layer.mask = maskLayer
    }
    
    func setupCollectionViewCell(weatherData: WeatherList){
        
        if WeatherCategory.partlyCloudy.rawValue == "Partly cloudy" {
            self.setupBackground(topColor: ColorConstant.partlyCloudyTop, bottomColor: ColorConstant.partlyCloudyBottom)
            
        } else if WeatherCategory.partlyCloudy.rawValue == "Sunny" {
            self.setupBackground(topColor: ColorConstant.sunnyTop, bottomColor: ColorConstant.sunnyBottom)
        }
        else if  WeatherCategory.partlyCloudy.rawValue == "Cloudy" {
            self.setupBackground(topColor: ColorConstant.cloudyTop, bottomColor: ColorConstant.cloudyBottom)
        }
        else {
            self.setupBackground(topColor: ColorConstant.otherTop, bottomColor: ColorConstant.otherBottom)
        }
        
        countryLbl.text = weatherData.country
        regionLbl.text = weatherData.region
        cityLbl.text = weatherData.city
        weatherLbl.text = weatherData.weather
        tempratureLbl.text = "\(weatherData.temprature)°"
        let apiURLStrings = weatherData.image
        weatherImage.downloaded(from: apiURLStrings)
        
    }
}
