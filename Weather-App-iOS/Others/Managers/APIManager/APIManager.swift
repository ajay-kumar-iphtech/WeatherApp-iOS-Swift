////Created by IPH Technologies Pvt. Ltd.
//
//import Foundation
//
import UIKit

class APIManager {
    
    //MARK: - shared instance
    static let shared = APIManager()
    
    //MARK: - Public functions
    
    func getWeatherData(city: String, days: Int = 1, completion: @escaping (Result<ForcastWeather, Error>) -> Void) {
        let apiURLString = APIUrlString.getForcastAPIURLString(query: city, days: days)
        guard let url = URL(string: apiURLString) else {
            print(" failed to get URL!")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
            if error == nil, let responseData = data {
                do {
                    
                    let jsonData = try JSONDecoder().decode(ForcastWeather.self, from: responseData)
                    completion(.success(jsonData))
                    
                }
                catch let error {
                    completion(.failure(error))
                }
                
            }
            else{
                print("No data found")
            }
        }.resume()
    }
}
