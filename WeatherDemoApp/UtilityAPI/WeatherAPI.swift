//
//  WeatherAPI.swift
//  WeatherDemoApp
//
//

import Foundation

class WeatherAPI {

    //note : Place your weather API key
    let weatherAPIkey = ""
    
    func getWeatherDetailAPI(country:String,letitude:String = "",logitude:String = "",  completion: @escaping (Result<WeatherData, Error>) -> Void) {
        
        var getUrl = "https://api.openweathermap.org/data/2.5/weather?q=\(country)&appid=\(weatherAPIkey)"
        if !letitude.isEmpty{
            getUrl = "https://api.openweathermap.org/data/2.5/weather?lat=\(letitude)&lon=\(logitude)&appid=\(weatherAPIkey)"
        }else{
            getUrl = "https://api.openweathermap.org/data/2.5/weather?q=\(country)&appid=\(weatherAPIkey)"
        }
        
        guard let url = URL(string:getUrl ) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "Details Not Found", code: 0, userInfo: nil)))
                return
            }
            do {
                let Countries = try JSONDecoder().decode(WeatherData.self, from: data)
                completion(.success(Countries))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
