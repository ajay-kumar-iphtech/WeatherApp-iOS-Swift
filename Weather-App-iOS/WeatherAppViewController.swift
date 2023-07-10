//
//  ViewController.swift
//  Weather-App-iOS
//
//  Created by iPHTech 29 on 01/06/23.
//
import MapKit
import UIKit
import CoreLocation

class WeatherAppViewController: UIViewController {
    
    var cityName = "" {
        didSet{
            print("cityNam",cityName)
            DispatchQueue.main.async {
                self.weatherAppCollectionView.reloadData()
            }
        }
    }
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherAppCollectionView: UICollectionView!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    var arrayList :[WeatherList] =  []
    var searchValue = ""
    var isMainViewHidden = false
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayList = WeatherList.defaultWeatherList()
        var cityName = getCityNameFromCoordinates(latitude: latitude, longitude: longitude)
        
        self.cityName =  cityName
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        
        setUpUI()
        
    }
    
    func setUpUI() {
        
        weatherAppCollectionView.delegate = self
        weatherAppCollectionView.dataSource = self
        Key.viewWillAppear = false
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if Key.viewWillAppear == false {
            if let weatherDataArray = getSavedWeatherData(){
                DispatchQueue.main.async {
                    self.arrayList = weatherDataArray
                    self.weatherAppCollectionView.reloadData()
                    Key.viewWillAppear = true
                }
            }
        }
    }
    
    func getSavedWeatherData() -> [WeatherList]?{
        //get data for city list
        let defaults = UserDefaults.standard
        let cityList = UserDefaultsManager.shared.getCityNameList()
        print(cityList)
        print("citylist = \(cityList.count)")
        if cityList.count > 0 {
            
            //city list found
            //iterate through all cities
            for city in cityList {
                let decoder = JSONDecoder()
                if let savedModel = defaults.value(forKey: city) as? Data ,
                   let decodedData = try? decoder.decode(WeatherList.self, from: savedModel) {
                    arrayList.append(decodedData)
                    print("arrayList = \(arrayList.count)")
                }
            }
            return arrayList
        }
        else {
            return nil
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        searchValue = searchTextField.text!
        
        
        if searchTextField.text?.isEmpty ?? true {
            showAlert(message: "Please enter a city name.")
        } else {
            let mainS = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainS.instantiateViewController(withIdentifier: "DescriptionViewController") as! DescriptionViewController
            vc.searchValue = searchValue
            
            self.navigationController?.pushViewController(vc, animated:true)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension WeatherAppViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Array's data are  = ", arrayList.count)
        print("arrayList", arrayList)
        return arrayList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = weatherAppCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeatherAppCollectionViewCell
        
        if arrayList[indexPath.row].weather == "Partly cloudy" {
            print("Partly cloudy")
            print(arrayList[indexPath.row].weather)
            let colorBottom =  UIColor(red: 81.0/255.0, green: 185.0/255.0, blue: 226.0/255.0, alpha: 1.0).cgColor
            let colorTop = UIColor(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorBottom]
            gradientLayer.locations = [0.0, 1.0]
            // gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            gradientLayer.frame = cell.mainView.bounds
            cell.mainView.layer.insertSublayer(gradientLayer, at:0)
            
            let cornerRadius = CGMutablePath()
            
            cornerRadius.move(to: CGPoint.init(x: 20, y: 0))
            cornerRadius.addLine(to: CGPoint.init(x: cell.mainView.bounds.width - 20, y: 0))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: cell.mainView.bounds.width, y: 20), control: CGPoint.init(x: cell.mainView.bounds.width, y: 0))
            cornerRadius.addLine(to: CGPoint.init(x: cell.mainView.bounds.width, y: cell.mainView.bounds.height - 20))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: cell.mainView.bounds.width - 20, y: cell.mainView.bounds.height), control: CGPoint.init(x: cell.mainView.bounds.width, y: cell.mainView.bounds.height))
            cornerRadius.addLine(to: CGPoint.init(x: 20, y: cell.mainView.bounds.height))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: 0, y: cell.mainView.bounds.height - 20), control: CGPoint.init(x: 0, y: cell.mainView.bounds.height))
            cornerRadius.addLine(to: CGPoint.init(x: 0, y: 20))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: 20, y: 0), control: CGPoint.init(x: 0, y: 0))
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = cornerRadius
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
            maskLayer.fillColor = UIColor.red.cgColor
            cell.mainView.layer.mask = maskLayer
            
        } else if arrayList[indexPath.row].weather == "Sunny" {
            print("Sunny")
            let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
            let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorBottom]
            gradientLayer.locations = [0.0, 1.0]
            //   gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            gradientLayer.frame = cell.mainView.bounds
            cell.mainView.layer.insertSublayer(gradientLayer, at:0)
            
            let cornerRadius = CGMutablePath()
            
            cornerRadius.move(to: CGPoint.init(x: 20, y: 0))
            cornerRadius.addLine(to: CGPoint.init(x: cell.mainView.bounds.width - 20, y: 0))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: cell.mainView.bounds.width, y: 20), control: CGPoint.init(x: cell.mainView.bounds.width, y: 0))
            cornerRadius.addLine(to: CGPoint.init(x: cell.mainView.bounds.width, y: cell.mainView.bounds.height - 20))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: cell.mainView.bounds.width - 20, y: cell.mainView.bounds.height), control: CGPoint.init(x: cell.mainView.bounds.width, y: cell.mainView.bounds.height))
            cornerRadius.addLine(to: CGPoint.init(x: 20, y: cell.mainView.bounds.height))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: 0, y: cell.mainView.bounds.height - 20), control: CGPoint.init(x: 0, y: cell.mainView.bounds.height))
            cornerRadius.addLine(to: CGPoint.init(x: 0, y: 20))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: 20, y: 0), control: CGPoint.init(x: 0, y: 0))
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = cornerRadius
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
            maskLayer.fillColor = UIColor.red.cgColor
            cell.mainView.layer.mask = maskLayer
        } else if arrayList[indexPath.row].weather == "Cloudy" {
            print("Rainy")
            let colorBottom =  UIColor(red: 156.0/255.0, green: 187.0/255.0, blue: 202.0/255.0, alpha: 1.0).cgColor
            let colorTop = UIColor(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorBottom]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            // gradientLayer.frame = cell.mainView.bounds
            cell.mainView.layer.insertSublayer(gradientLayer, at:0)
            
            let cornerRadius = CGMutablePath()
            
            cornerRadius.move(to: CGPoint.init(x: 20, y: 0))
            cornerRadius.addLine(to: CGPoint.init(x: cell.mainView.bounds.width - 20, y: 0))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: cell.mainView.bounds.width, y: 20), control: CGPoint.init(x: cell.mainView.bounds.width, y: 0))
            cornerRadius.addLine(to: CGPoint.init(x: cell.mainView.bounds.width, y: cell.mainView.bounds.height - 20))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: cell.mainView.bounds.width - 20, y: cell.mainView.bounds.height), control: CGPoint.init(x: cell.mainView.bounds.width, y: cell.mainView.bounds.height))
            cornerRadius.addLine(to: CGPoint.init(x: 20, y: cell.mainView.bounds.height))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: 0, y: cell.mainView.bounds.height - 20), control: CGPoint.init(x: 0, y: cell.mainView.bounds.height))
            cornerRadius.addLine(to: CGPoint.init(x: 0, y: 20))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: 20, y: 0), control: CGPoint.init(x: 0, y: 0))
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = cornerRadius
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
            maskLayer.fillColor = UIColor.red.cgColor
            cell.mainView.layer.mask = maskLayer
        } else  {
            let colorTop =  UIColor(red: 212.0/255.0, green: 66.0/255.0, blue: 226.0/255.0, alpha: 1.0).cgColor
            let colorBottom = UIColor(red: 68.0/255.0, green: 71.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorBottom]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            //  gradientLayer.frame = cell.mainView.bounds
            cell.mainView.layer.insertSublayer(gradientLayer, at:0)
            
            let cornerRadius = CGMutablePath()
            
            cornerRadius.move(to: CGPoint.init(x: 20, y: 0))
            cornerRadius.addLine(to: CGPoint.init(x: cell.mainView.bounds.width - 20, y: 0))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: cell.mainView.bounds.width, y: 20), control: CGPoint.init(x: cell.mainView.bounds.width, y: 0))
            cornerRadius.addLine(to: CGPoint.init(x: cell.mainView.bounds.width, y: cell.mainView.bounds.height - 20))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: cell.mainView.bounds.width - 20, y: cell.mainView.bounds.height), control: CGPoint.init(x: cell.mainView.bounds.width, y: cell.mainView.bounds.height))
            cornerRadius.addLine(to: CGPoint.init(x: 20, y: cell.mainView.bounds.height))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: 0, y: cell.mainView.bounds.height - 20), control: CGPoint.init(x: 0, y: cell.mainView.bounds.height))
            cornerRadius.addLine(to: CGPoint.init(x: 0, y: 20))
            cornerRadius.addQuadCurve(to: CGPoint.init(x: 20, y: 0), control: CGPoint.init(x: 0, y: 0))
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = cornerRadius
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
            maskLayer.fillColor = UIColor.red.cgColor
            cell.mainView.layer.mask = maskLayer
        }
        
        cell.countryLbl.text = arrayList[indexPath.row].country
        cell.regionLbl.text = arrayList[indexPath.row].region
        
        cell.cityLbl.text = cityName
        cell.weatherLbl.text = arrayList[indexPath.row].weather
        cell.tempratureLbl.text = "\(arrayList[indexPath.row].temprature)°"
        let apiURLStrings = arrayList[indexPath.row].image
        cell.weatherImage.downloaded(from: apiURLStrings)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mainS = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainS.instantiateViewController(withIdentifier: "DescriptionViewController") as! DescriptionViewController
        vc.city = arrayList[indexPath.row].city
        vc.temp = arrayList[indexPath.row].temprature
        vc.weatherImg = arrayList[indexPath.row].image
        vc.uvData = arrayList[indexPath.row].uvIndex
        vc.day = arrayList[indexPath.row].region
        vc.sunset = arrayList[indexPath.row].sunset
        vc.sunrise = arrayList[indexPath.row].sunrise
        vc.date = arrayList[indexPath.row].date
        vc.humidity = arrayList[indexPath.row].humidity
        vc.windKph = arrayList[indexPath.row].windKph
        
        let alertController = UIAlertController(title: "Delete Cell", message: "Are you sure you want to delete this cell?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.arrayList.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
        }
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
        
        
        //self.navigationController?.pushViewController(vc, animated:true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        return CGSize(width: width - 40, height: width/2 - 50)
    }
}


extension WeatherAppViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // Location authorization granted, start updating location
            locationManager.stopUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // Do something with the user's location coordinates
        print("Latitude: \(latitude), Longitude: \(longitude)")
        
        let str =  getCityNameFromCoordinates(latitude: latitude, longitude: longitude)
        print("str is = ", str)
        
        // Stop updating location to conserve battery
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location error
        print("Location update failed with error: \(error.localizedDescription)")
    }
    
    
    func getCityNameFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> String {
        var str = " "
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                // Handle geocoding error
                print("Reverse geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                if let city = placemark.locality {
                    print("City: \(city)")
                    self.cityName = city
                    DispatchQueue.main.async {
                        self.cityNameLabel.text = city
                        str = city
                    }
                }
            }
        }
        return str
    }
    
}
