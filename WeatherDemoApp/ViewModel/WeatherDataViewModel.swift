//
//  WeatherDataViewModel.swift
//  WeatherDemoApp
//
//

import Foundation
class WeatherDataViewModel: ObservableObject {
        @Published var weatherData: WeatherData?
        
        @Published var searchText: String = "" {
            didSet {
                guard !searchText.isEmpty else { return }
                Task {
                    self.fetchWeatherData(text: "")
                }
            }
        }
        private var apiClient = WeatherAPI()
        
        init() {
//            Task {
//                fetchWeatherData(country: country)
//            }
        }
        func fetchWeatherData(text:String,lat:String = "",log:String = ""){
           
            apiClient.getWeatherDetailAPI(country: text,letitude: lat,logitude: log, completion: { result in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            if !text.isEmpty{
                                UserDefaults.standard.setValue(text, forKey: "country")
                                UserDefaults.standard.synchronize()
                            }
                            self.weatherData = data
                           
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            
                        self.showErrorAlert(message: error.localizedDescription)
                        }
                    }
                })
        }
        func showErrorAlert(message: String) {
            print("Error",message)
        }
    }
