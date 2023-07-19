////Created by IPH Technologies Pvt. Ltd.
//
//import Foundation
//
//class APIManager{
//
//    static var shared = APIManager()
//    /// json serialization
//    func callDataFromAPI() {
//        let session = URLSession.shared
//        let serviceUrl = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=20cbed94eb3249a8896170136232705&q=\(searchValue)&days=1&aqi=no&alerts=no")
//
//        let task = session.dataTask(with: serviceUrl!) { [weak self] (data, response, error) in
//            if error == nil {
//                let httpResponse = response as! HTTPURLResponse
//                if httpResponse.statusCode == 200 {
//                    let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
//                    if let result = jsonData as? [String: Any],
//                       let forecast = result["forecast"] as? [String: Any],
//                       let forecastDay = forecast["forecastday"] as? [[String: Any]],
//                       let firstDay = forecastDay.first,
//                       let date = firstDay["date"] as? String,
//                       let day = firstDay["day"] as? [String: Any],
//                       let humidity = day["avghumidity"] as? Int,
//                       let condition = day["condition"] as? [String: Any],
//                       let weather = condition["text"] as? String,
//                       let temperature = day["avgtemp_c"] as? Double {
//
//                        DispatchQueue.main.async {
//                            // Perform UI updates on the main thread
//                           
//                            self?.dateLbl.text = date
//                            self?.humidityLbl.text = "\(humidity)%"
//                            self?.weatherNameLbl.text = weather
//                            self?.tempretureLbl.text = "\(temperature)°C"
//                        }
//                    }
//                }
//            }
//        }
//        task.resume()
//    }
//}
