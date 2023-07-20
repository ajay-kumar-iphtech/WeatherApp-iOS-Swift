//
//  ViewController.swift
//  Weather-App-iOS
//
//  Created by iPHTech 29 on 01/06/23.
//
import MapKit
import UIKit
import CoreLocation
var dataSave = true
var str = " "

class WeatherAppViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherAppCollectionView: UICollectionView!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    //MARK: - variables
    var cityName = ""
    var arrayList :[ForcastWeather] = []{
        didSet{
            DispatchQueue.main.async {
                self.weatherAppCollectionView.reloadData()
            }
        }
    }
    var searchValue = ""
    var isMainViewHidden = false
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var selectedCityName: String?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //assign location delegate
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        
        //collection view delegate
        weatherAppCollectionView.delegate = self
        weatherAppCollectionView.dataSource = self
        
        //need to check
        Key.viewWillAppear = false
        
    }
    
    /// if we remove this code the cell will not visible on save data
    override func viewWillAppear(_ animated: Bool) {
        let cities = UserDefaultsManager.shared.getCityNameList()
        if let citiesData = UserDefaultsManager.shared.getAllCityData(cityArray: cities) {
            arrayList = citiesData
        }
    }
    
//    func getWeatherData() -> [WeatherList]?{
//        //get cities list
//        var weatherDataArray = [WeatherList]()
//        let cityList = UserDefaultsManager.shared.getCityNameList()
//        if cityList.count > 0 {
//            //city list found
//            //iterate through all cities
//            for city in cityList {
//                let decoder = JSONDecoder()
//                if let savedDataInUserDefault = defaults.value(forKey: city) as? Data ,
//                   let cityWeatherData = try? decoder.decode(WeatherList.self, from: savedDataInUserDefault) {
//                    weatherDataArray.append(cityWeatherData)
//                }
//            }
//            return weatherDataArray
//        }
//        else {
//            return nil
//        }
//    }
    
    @IBAction func searchButton(_ sender: Any) {
        searchValue = searchTextField.text!
        
        
        if searchTextField.text?.isEmpty ?? true {
            showAlert(message: "Please enter a city name.")
        } else {
            let mainS = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainS.instantiateViewController(withIdentifier: "DescriptionViewController") as! DescriptionViewController
            vc.searchValue = searchValue
            print(searchTextField)
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
        print(arrayList.count)
        return arrayList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weatherAppCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeatherAppCollectionViewCell
        
        
        

        cell.setupCollectionViewCell(weatherData: arrayList[indexPath.row])
      //  cell.cityLbl.text = str
        let UserDefaultsKeys = "\(searchValue)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mainS = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainS.instantiateViewController(withIdentifier: "DescriptionViewController") as! DescriptionViewController
        vc.city = arrayList[indexPath.row].location?.name ?? ""
        vc.temp = "\(arrayList[indexPath.row].current?.tempC ?? 0)"
//        vc.weatherImg = arrayList[indexPath.row].image
//        vc.uvData = arrayList[indexPath.row].uvIndex
//        vc.day = arrayList[indexPath.row].region
//        vc.sunset = arrayList[indexPath.row].sunset
//        vc.sunrise = arrayList[indexPath.row].sunrise
//        vc.date = arrayList[indexPath.row].date
//        vc.humidity = arrayList[indexPath.row].humidity
//        vc.windKph = arrayList[indexPath.row].windKph
//        
//        selectedCityName = arrayList[indexPath.row].city

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
        
        print("Latitude: \(latitude), Longitude: \(longitude)")
        
        getCityNameFromCoordinates(latitude: latitude, longitude: longitude) { cityName in
            if !UserDefaultsManager.shared.isCityDataPresent(cityName: cityName){
                APIManager.shared.getWeatherData(city: "\(cityName)") { result in
                    switch result {
                    case .success(let forcastData):
                        DispatchQueue.main.async {
                            UserDefaultsManager.shared.addCityData(cityName: cityName, data: forcastData)
                            UserDefaultsManager.shared.addCityName(cityName: cityName)
                            self.arrayList.append(forcastData)
                        }
                    case .failure(let error):
                        
                        print(error)
                    }
                }
            }
            else {
                //show popup :- city already present
//                let alertController = UIAlertController(title: "Alert", message: "This data is already present", preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }
        print("the value of str is = ", str)
        locationManager.stopUpdatingLocation()
    }
   
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
    
    
    func getCityNameFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees,  completion : @escaping (String) -> Void )  {
        
     
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                return
            }
           
            if let placemark = placemarks?.first {
                if let city = placemark.locality {
                    self.cityNameLabel.text = city
                    str = city
                    
                    // Save the city name to UserDefaults
                    UserDefaults.standard.set(str, forKey: "cityName")
                    completion(city)
                }
                else {
                    completion("")
                }
            }
        }
     
    }
    
}
