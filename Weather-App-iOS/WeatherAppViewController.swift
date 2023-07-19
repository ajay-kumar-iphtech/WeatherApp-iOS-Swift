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
    var cityName = "" {
        didSet{
            DispatchQueue.main.async {
                self.weatherAppCollectionView.reloadData()
                self.cityName = self.cityName
            }
        }
    }
    var arrayList :[WeatherList] =  []
    var searchValue = ""
    var isMainViewHidden = false
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var selectedCityName: String?

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        arrayList = WeatherList.defaultWeatherList()
        let cityName = getCityNameFromCoordinates(latitude: latitude, longitude: longitude) { cityName in
            self.cityName = cityName
            print("cityName = ", cityName)
        }

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
        if Key.viewWillAppear == false {
            if let weatherDataArray = getWeatherData(){
                DispatchQueue.main.async {
                    self.arrayList = weatherDataArray
                    self.weatherAppCollectionView.reloadData()
                    //need to check
                    Key.viewWillAppear = true
                }
            }
        }
    }
    
    func getWeatherData() -> [WeatherList]?{
        //get cities list
        var weatherDataArray = [WeatherList]()
        let cityList = UserDefaultsManager.shared.getCityNameList()
        if cityList.count > 0 {
            //city list found
            //iterate through all cities
            for city in cityList {
                let decoder = JSONDecoder()
                if let savedDataInUserDefault = defaults.value(forKey: city) as? Data ,
                   let cityWeatherData = try? decoder.decode(WeatherList.self, from: savedDataInUserDefault) {
                    weatherDataArray.append(cityWeatherData)
                }
            }
            return weatherDataArray
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
        print(arrayList.count)
        return arrayList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weatherAppCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeatherAppCollectionViewCell
        

        cell.setupCollectionViewCell(weatherData: arrayList[indexPath.row])
        cell.cityLbl.text = str

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
        
        selectedCityName = arrayList[indexPath.row].city
        collectionView.reloadData()

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
        
        var str =  getCityNameFromCoordinates(latitude: latitude, longitude: longitude) { cityName in
            self.cityName = cityName
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
                   completion(city)
                }
                else {
                    completion("")
                }
            }
        }
     
    }
    
}
