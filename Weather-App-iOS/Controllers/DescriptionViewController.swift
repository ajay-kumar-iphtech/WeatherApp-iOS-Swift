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
    var apiWeatherValue:ForcastWeather? = nil
    var previousSelected : IndexPath?
    var currentSelected : Int?
    var currentLocation: CLLocation!
    
    
    //MARK: Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionCollectionView.dataSource = self
        descriptionCollectionView.delegate = self
//         locationManager.delegate = self
        
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
        if !UserDefaultsManager.shared.isCityDataPresent(cityName: searchValue){
            APIManager.shared.getWeatherData(city: searchValue, days: 1) { result in
                switch result {
                case .success(let forcastData):
                    print(forcastData)
                    self.apiWeatherValue = forcastData
                    DispatchQueue.main.async { [self] in
                        cityNameLbl.text = forcastData.location?.name ?? ""
                        regionlbl.text = forcastData.location?.region ?? ""
                        weatherNameLbl.text = forcastData.current?.condition?.text ?? ""
                        tempretureLbl.text =  "\(forcastData.current?.tempC ?? 0)"
                        uvLabel.text = "\(forcastData.current?.uv ?? 0)"
                        sunriseLabel.text = "sunrise \(forcastData.forecast?.forecastday?.first?.astro?.sunrise ?? "00:00")"
                        sunsetLabel.text = "sunset \(forcastData.forecast?.forecastday?.first?.astro?.sunset ?? "00:00")"
                        dateLbl.text = forcastData.forecast?.forecastday?.first?.date ?? "00-00-0000"
                        humidityLbl.text = "\(forcastData.current?.humidity ?? 0)"
                        
                        let apiURLStrings = "https:\(String(describing: forcastData.current?.condition?.icon ?? ""))"
                        weatherImage.downloaded(from: apiURLStrings)
                        
                    }
                case .failure(let error):
                    
                    print(error)
                }
            }
        }
        else {
            //show popup :- city already present
//            let alertController = UIAlertController(title: "Alert", message: "This data is already present", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        setUpUI()
    }
    
    
    //MARK: setUpUI
    func setUpUI() {
        
        saveDataButton.layer.cornerRadius = 15
        saveDataButton.layer.borderWidth = 0.5
        saveDataButton.layer.masksToBounds = false
        saveDataButton.layer.borderColor = UIColor.black.cgColor
        
        APIManager.shared.getWeatherData(city: searchValue, days: 1) { result in
            switch result {
            case .success(let forcastData):
                print(forcastData)
                self.apiWeatherValue = forcastData
                DispatchQueue.main.async { [self] in
                    cityNameLbl.text = forcastData.location?.name ?? ""
                    regionlbl.text = forcastData.location?.region ?? ""
                    weatherNameLbl.text = forcastData.current?.condition?.text ?? ""
                    tempretureLbl.text =  "\(forcastData.current?.tempC ?? 0)"
                    uvLabel.text = "\(forcastData.current?.uv ?? 0)"
                    sunriseLabel.text = "sunrise \(forcastData.forecast?.forecastday?.first?.astro?.sunrise ?? "00:00")"
                    sunsetLabel.text = "sunset \(forcastData.forecast?.forecastday?.first?.astro?.sunset ?? "00:00")"
                    dateLbl.text = forcastData.forecast?.forecastday?.first?.date ?? "00-00-0000"
                    humidityLbl.text = "\(forcastData.current?.humidity ?? 0)"
                    
                    let apiURLStrings = "https:\(String(describing: forcastData.current?.condition?.icon ?? ""))"
                    weatherImage.downloaded(from: apiURLStrings)
                    
                }
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    //MARK: ButtonAction
    @IBAction func SaveButtonAction(_ sender: Any) {
       
        let UserDefaultsKeys = "\(searchValue)"
        let defaults = UserDefaults.standard
        
        if apiWeatherValue != nil {
            Key.viewWillAppear = false
            UserDefaultsManager.shared.addCityName(cityName: UserDefaultsKeys)
            UserDefaultsManager.shared.addCityData(cityName: UserDefaultsKeys, data: apiWeatherValue!)

        }else {
            //show popup :- city already present
            let alertController = UIAlertController(title: "Alert", message: "This data is already present", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
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
        self.descriptionCollectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        return CGSize(width: width/4 - 20, height: width/3 + 40)
    }
    
}
