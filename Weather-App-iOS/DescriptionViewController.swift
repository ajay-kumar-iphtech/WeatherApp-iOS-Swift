//
//  DescriptionViewController.swift
//  Weather-App-iOS
//
//  Created by iPHTech 29 on 05/06/23.
//

import UIKit
import MKMagneticProgress
import CoreLocation

class DescriptionViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var weatherNameLbl: UILabel!
    @IBOutlet weak var tempretureLbl: UILabel!
    @IBOutlet weak var uvLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var regionlbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var uvProgress: UIProgressView!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var speedoMeterView : UIView!
    @IBOutlet weak var magProgress:MKMagneticProgress!
    @IBOutlet weak var descriptionCollectionView: UICollectionView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var uvIndexView: UIView!
    @IBOutlet weak var windView: UIView!
    @IBOutlet weak var sunriseView: UIView!
    @IBOutlet weak var humidityView: UIView!
    @IBOutlet weak var wind1View: UIView!
    @IBOutlet weak var saveDataButton: UIButton!
    
    
    
    
    
    //MARK: Properties
    private let speedometerView = SpeedometerView(frame: .zero, maxSpeed: 200)
    var city = ""
    var weather = ""
    var temp = ""
    var weatherImg = ""
    var uvData = ""
    var sunrise = ""
    var sunset = ""
    var date = ""
    var day = ""
    var humidity = ""
    var windKph = ""
    var searchValue = ""
    var apiWeatherValue:WeatherList? = nil
    var previousSelected : IndexPath?
    var currentSelected : Int?
    var currentLocation: CLLocation!
    
    //MARK: Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionCollectionView.dataSource = self
        descriptionCollectionView.delegate = self
        // locationManager.delegate = self
        
        cityNameLbl.text = city
        tempretureLbl.text = "\(temp)°"
        weatherNameLbl.text = day
        uvLabel.text = uvData
        regionlbl.text = day
        dateLbl.text = date
        sunriseLabel.text = "Sunrise:\(sunrise)"
        sunsetLabel.text = "Sunset:\(sunset)"
        humidityLbl.text = "\(humidity)%"
        
        showProgressView()
        self.speedometerView.setSpeed(CGFloat(Int(windKph) ?? 0))
        print(windKph)
        speedoMeterView.addSubview(speedometerView)
        setCornerRadius()
          getDataFromAPI()
        callDataFromAPI()
        setUpUI()
    }
    
    //MARK: setUpUI
    func setUpUI() {
        
        saveDataButton.layer.cornerRadius = 15
        saveDataButton.layer.borderWidth = 0.5
        saveDataButton.layer.masksToBounds = false
        saveDataButton.layer.borderColor = UIColor.black.cgColor
    }
    
    
    //MARK: API Function
    func getDataFromAPI() {
        let apiURLString = "https://api.weatherapi.com/v1/forecast.json?key=20cbed94eb3249a8896170136232705&q=\(searchValue)&days=1&aqi=no&alerts=no"
        guard let url = URL(string: apiURLString) else {
            print(" failed to get URL!")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
            if error == nil, let responseData = data {
                do {
                    let jsonData = try JSONDecoder().decode(Root.self, from: responseData)
                    let image = "https:\(jsonData.current.condition.icon.rawValue)"
                    let weather = jsonData.current.condition.text.rawValue
                    let country = jsonData.location.country
                    let region = jsonData.location.region
                    let city = jsonData.location.name
                    let temprature = "\(jsonData.current.tempC)"
                    let uvIndex = "\(jsonData.current.uv)"
                    let date = jsonData.forecast.forecastday[0].date
                    let sunrise = jsonData.forecast.forecastday[0].astro.sunrise
                    let sunset = jsonData.forecast.forecastday[0].astro.sunset
                    let humidity = "\(jsonData.current.humidity)"
                    let windKph = "45"
                    
                    apiWeatherValue = WeatherList(weather: weather, country: country,region: region,city: city, temprature: temprature, image: image, uvIndex: uvIndex,sunrise: sunrise ,sunset: sunset,date: date, humidity: humidity, windKph: windKph)
                    DispatchQueue.main.async { [self] in
                        cityNameLbl.text = city
                        regionlbl.text = region
                        weatherNameLbl.text = weather
                        tempretureLbl.text = "\(temprature)°"
                        uvLabel.text = uvIndex
                        sunriseLabel.text = "sunrise \(sunrise)"
                        sunsetLabel.text = "sunset \(sunset)"
                        dateLbl.text = date
                        humidityLbl.text = "\(humidity)%"
                        
                        let apiURLStrings = image
                        weatherImage.downloaded(from: apiURLStrings)
                        
                    }
                    
                }
                catch let error {
                    print(error.localizedDescription)
                }
                
            }
            else{
                print("No data found")
            }
        }.resume()
    }
    
    /// json serialization
    func callDataFromAPI() {
        let session = URLSession.shared
        let serviceUrl = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=20cbed94eb3249a8896170136232705&q=\(searchValue)&days=1&aqi=no&alerts=no")

        let task = session.dataTask(with: serviceUrl!) { [weak self] (data, response, error) in
            if error == nil {
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    if let result = jsonData as? [String: Any],
                       let forecast = result["forecast"] as? [String: Any],
                       let forecastDay = forecast["forecastday"] as? [[String: Any]],
                       let firstDay = forecastDay.first,
                       let date = firstDay["date"] as? String,
                       let day = firstDay["day"] as? [String: Any],
                       let humidity = day["avghumidity"] as? Int,
                       let condition = day["condition"] as? [String: Any],
                       let weather = condition["text"] as? String,
                       let temperature = day["avgtemp_c"] as? Double {

                        DispatchQueue.main.async {
                            // Perform UI updates on the main thread
                            self?.dateLbl.text = date
                            self?.humidityLbl.text = "\(humidity)%"
                            self?.weatherNameLbl.text = weather
                            self?.tempretureLbl.text = "\(temperature)°C"
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
//    func getCityNameFromCoordinates(latitude: latitude, longitude: longitude) {
//        
//        
//        
//    }
    
    
    
    //MARK: ButtonAction
    @IBAction func saveAPIData(_ sender: Any) {
        let UserDefaultsKeys = "\(searchValue)"
        let defaults = UserDefaults.standard
        
        if let data = apiWeatherValue {
            Key.viewWillAppear = false
            UserDefaultsManager.shared.addCityName(cityName: UserDefaultsKeys)
            
            if let encoded = try? JSONEncoder().encode(apiWeatherValue) {
                defaults.set(encoded, forKey: UserDefaultsKeys)
            }
            let decoder = JSONDecoder()
            if let savedModel = defaults.value(forKey: UserDefaultsKeys) as? Data ,
               let decodedData = try? decoder.decode(WeatherList.self, from: savedModel) {
                print("Decoded data: \(decodedData)")
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGradientBackground()
        setGradientBackground2()
        setGradientBackground3()
        setGradientBackground4()
        setGradientBackground5()
        setGradientBackground6()
        
    }
    
    //MARK: GradientFunction
    func setGradientBackground() {
        
        let colorTop =  UIColor(red: 212.0/255.0, green: 66.0/255.0, blue: 226.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 68.0/255.0, green: 71.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.descriptionView.bounds
        self.descriptionView.layer.insertSublayer(gradientLayer, at:0)
        
        let cornerRadius = CGMutablePath()
        cornerRadius.move(to: CGPoint.init(x: 20, y: 0))
        cornerRadius.addLine(to: CGPoint.init(x: descriptionView.bounds.width - 20, y: 0))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: descriptionView.bounds.width, y: 20), control: CGPoint.init(x: descriptionView.bounds.width, y: 0))
        cornerRadius.addLine(to: CGPoint.init(x: descriptionView.bounds.width, y: descriptionView.bounds.height - 20))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: descriptionView.bounds.width - 20, y: descriptionView.bounds.height), control: CGPoint.init(x: descriptionView.bounds.width, y: descriptionView.bounds.height))
        cornerRadius.addLine(to: CGPoint.init(x: 20, y: descriptionView.bounds.height))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: 0, y: descriptionView.bounds.height - 20), control: CGPoint.init(x: 0, y: descriptionView.bounds.height))
        cornerRadius.addLine(to: CGPoint.init(x: 0, y: 20))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: 20, y: 0), control: CGPoint.init(x: 0, y: 0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = cornerRadius
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillColor = UIColor.red.cgColor
        descriptionView.layer.mask = maskLayer
        
    }
    func setGradientBackground2() {
        
        let colorTop =  UIColor(red: 212.0/255.0, green: 66.0/255.0, blue: 226.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 68.0/255.0, green: 71.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.sunriseView.bounds
        self.sunriseView.layer.insertSublayer(gradientLayer, at:0)
        
        let cornerRadius = CGMutablePath()
        cornerRadius.move(to: CGPoint.init(x: 20, y: 0))
        cornerRadius.addLine(to: CGPoint.init(x: sunriseView.bounds.width - 20, y: 0))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: sunriseView.bounds.width, y: 20), control: CGPoint.init(x: sunriseView.bounds.width, y: 0))
        cornerRadius.addLine(to: CGPoint.init(x: sunriseView.bounds.width, y: sunriseView.bounds.height - 20))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: sunriseView.bounds.width - 20, y: sunriseView.bounds.height), control: CGPoint.init(x: sunriseView.bounds.width, y: sunriseView.bounds.height))
        cornerRadius.addLine(to: CGPoint.init(x: 20, y: sunriseView.bounds.height))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: 0, y: sunriseView.bounds.height - 20), control: CGPoint.init(x: 0, y: sunriseView.bounds.height))
        cornerRadius.addLine(to: CGPoint.init(x: 0, y: 20))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: 20, y: 0), control: CGPoint.init(x: 0, y: 0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = cornerRadius
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillColor = UIColor.red.cgColor
        sunriseView.layer.mask = maskLayer
        
    }
    func setGradientBackground3() {
        
        let colorTop =  UIColor(red: 212.0/255.0, green: 66.0/255.0, blue: 226.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 68.0/255.0, green: 71.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.uvIndexView.bounds
        self.uvIndexView.layer.insertSublayer(gradientLayer, at:0)
        
        let cornerRadius = CGMutablePath()
        cornerRadius.move(to: CGPoint.init(x: 20, y: 0))
        cornerRadius.addLine(to: CGPoint.init(x: uvIndexView.bounds.width - 20, y: 0))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: uvIndexView.bounds.width, y: 20), control: CGPoint.init(x: uvIndexView.bounds.width, y: 0))
        cornerRadius.addLine(to: CGPoint.init(x: uvIndexView.bounds.width, y: uvIndexView.bounds.height - 20))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: uvIndexView.bounds.width - 20, y: uvIndexView.bounds.height), control: CGPoint.init(x: uvIndexView.bounds.width, y: uvIndexView.bounds.height))
        cornerRadius.addLine(to: CGPoint.init(x: 20, y: uvIndexView.bounds.height))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: 0, y: uvIndexView.bounds.height - 20), control: CGPoint.init(x: 0, y: uvIndexView.bounds.height))
        cornerRadius.addLine(to: CGPoint.init(x: 0, y: 20))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: 20, y: 0), control: CGPoint.init(x: 0, y: 0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = cornerRadius
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillColor = UIColor.red.cgColor
        uvIndexView.layer.mask = maskLayer
    }
    func setGradientBackground4() {
        
        let colorTop =  UIColor(red: 212.0/255.0, green: 66.0/255.0, blue: 226.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 68.0/255.0, green: 71.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.windView.bounds
        self.windView.layer.insertSublayer(gradientLayer, at:0)
        
        let cornerRadius = CGMutablePath()
        cornerRadius.move(to: CGPoint.init(x: 20, y: 0))
        cornerRadius.addLine(to: CGPoint.init(x: windView.bounds.width - 20, y: 0))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: windView.bounds.width, y: 20), control: CGPoint.init(x: windView.bounds.width, y: 0))
        cornerRadius.addLine(to: CGPoint.init(x: windView.bounds.width, y: windView.bounds.height - 20))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: windView.bounds.width - 20, y: windView.bounds.height), control: CGPoint.init(x: windView.bounds.width, y: windView.bounds.height))
        cornerRadius.addLine(to: CGPoint.init(x: 20, y: windView.bounds.height))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: 0, y: windView.bounds.height - 20), control: CGPoint.init(x: 0, y: windView.bounds.height))
        cornerRadius.addLine(to: CGPoint.init(x: 0, y: 20))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: 20, y: 0), control: CGPoint.init(x: 0, y: 0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = cornerRadius
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillColor = UIColor.red.cgColor
        windView.layer.mask = maskLayer
    }
    
    func setGradientBackground5() {
        
        let colorTop =  UIColor(red: 212.0/255.0, green: 66.0/255.0, blue: 226.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 68.0/255.0, green: 71.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.humidityView.bounds
        self.humidityView.layer.insertSublayer(gradientLayer, at:0)
        
        let cornerRadius = CGMutablePath()
        cornerRadius.move(to: CGPoint.init(x: 20, y: 0))
        cornerRadius.addLine(to: CGPoint.init(x: humidityView.bounds.width - 20, y: 0))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: humidityView.bounds.width, y: 20), control: CGPoint.init(x: humidityView.bounds.width, y: 0))
        cornerRadius.addLine(to: CGPoint.init(x: humidityView.bounds.width, y: humidityView.bounds.height - 20))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: humidityView.bounds.width - 20, y: humidityView.bounds.height), control: CGPoint.init(x: humidityView.bounds.width, y: humidityView.bounds.height))
        cornerRadius.addLine(to: CGPoint.init(x: 20, y: humidityView.bounds.height))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: 0, y: humidityView.bounds.height - 20), control: CGPoint.init(x: 0, y: humidityView.bounds.height))
        cornerRadius.addLine(to: CGPoint.init(x: 0, y: 20))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: 20, y: 0), control: CGPoint.init(x: 0, y: 0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = cornerRadius
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillColor = UIColor.red.cgColor
        humidityView.layer.mask = maskLayer
    }
    func setGradientBackground6() {
        
        let colorTop =  UIColor(red: 212.0/255.0, green: 66.0/255.0, blue: 226.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 68.0/255.0, green: 71.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.wind1View.bounds
        self.wind1View.layer.insertSublayer(gradientLayer, at:0)
        
        let cornerRadius = CGMutablePath()
        cornerRadius.move(to: CGPoint.init(x: 20, y: 0))
        cornerRadius.addLine(to: CGPoint.init(x: wind1View.bounds.width - 20, y: 0))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: wind1View.bounds.width, y: 20), control: CGPoint.init(x: wind1View.bounds.width, y: 0))
        cornerRadius.addLine(to: CGPoint.init(x: wind1View.bounds.width, y: wind1View.bounds.height - 20))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: wind1View.bounds.width - 20, y: wind1View.bounds.height), control: CGPoint.init(x: wind1View.bounds.width, y: wind1View.bounds.height))
        cornerRadius.addLine(to: CGPoint.init(x: 20, y: wind1View.bounds.height))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: 0, y: wind1View.bounds.height - 20), control: CGPoint.init(x: 0, y: wind1View.bounds.height))
        cornerRadius.addLine(to: CGPoint.init(x: 0, y: 20))
        cornerRadius.addQuadCurve(to: CGPoint.init(x: 20, y: 0), control: CGPoint.init(x: 0, y: 0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = cornerRadius
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillColor = UIColor.red.cgColor
        wind1View.layer.mask = maskLayer
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        speedometerView.frame.size = CGSize(width: 120 , height: 120)
        self.speedometerView.center = CGPoint(x: speedoMeterView.bounds.midX, y: speedoMeterView.bounds.midY + 10)
    }
    
    func setCornerRadius() {
        descriptionView.layer.cornerRadius = 12
        sunriseView.layer.cornerRadius = 12
        humidityView.layer.cornerRadius = 12
        uvIndexView.layer.cornerRadius = 12
        windView.layer.cornerRadius = 12
        wind1View.layer.cornerRadius = 12
        
    }
    func showProgressView() {
        magProgress.setProgress(progress: 0.5, animated: true)
        magProgress.lineWidth = 5
        magProgress.orientation = .bottom
        magProgress.lineCap = .round
        magProgress.spaceDegree = 80
        magProgress.title = ""
        magProgress.titleColor = .white
        magProgress.percentLabelFormat = ""
    }
    
}

//MARK: -extension
extension DescriptionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCell", for: indexPath) as! DescriptionCollectionViewCell
        
        let today = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd MMM"
        cell.currentDateLbl.text = dateFormat.string(from: today)
        
        if currentSelected != nil && currentSelected == indexPath.row
        {
            
            //  cell.forecastView.backgroundColor = UIColor.green
            let colorTop =  UIColor(red: 212.0/255.0, green: 66.0/255.0, blue: 226.0/255.0, alpha: 1.0).cgColor
            let colorBottom = UIColor(red: 68.0/255.0, green: 71.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorBottom]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.frame =   cell.forecastView.bounds
            cell.forecastView.layer.insertSublayer(gradientLayer, at:0)
            
            let cornerRadius = CGMutablePath()
            
            cornerRadius.move(to: CGPoint.init(x: 20, y: 0))
            cornerRadius.addLine(to: CGPoint.init(x: cell.forecastView.bounds.width - 20, y: 0))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: cell.forecastView.bounds.width, y: 20), control: CGPoint.init(x: cell.forecastView.bounds.width, y: 0))
            cornerRadius.addLine(to: CGPoint.init(x: cell.forecastView.bounds.width, y: cell.forecastView.bounds.height - 20))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: cell.forecastView.bounds.width - 20, y: cell.forecastView.bounds.height), control: CGPoint.init(x: cell.forecastView.bounds.width, y: cell.forecastView.bounds.height))
            cornerRadius.addLine(to: CGPoint.init(x: 20, y: cell.forecastView.bounds.height))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: 0, y: cell.forecastView.bounds.height - 20), control: CGPoint.init(x: 0, y: cell.forecastView.bounds.height))
            cornerRadius.addLine(to: CGPoint.init(x: 0, y: 20))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: 20, y: 0), control: CGPoint.init(x: 0, y: 0))
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = cornerRadius
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
            maskLayer.fillColor = UIColor.red.cgColor
            cell.forecastView.layer.mask = maskLayer
            
            
        }else{
            cell.forecastView.backgroundColor = UIColor.white
        }
        cell.backgroundColor = .clear
        cell.forecastView.layer.cornerRadius = 26
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelected = indexPath.row
        // For reload the selected cell
        self.descriptionCollectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        return CGSize(width: width/4 - 20, height: width/3 + 40)
    }
    
}



