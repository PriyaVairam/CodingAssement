
//
//  ContentView.swift
//  WeatherApp
//
//

import SwiftUI

struct WeatherDetailView: View {
    
    @ObservedObject private var viewModel = WeatherDataViewModel()
    @StateObject private var networkMonitor = InternetCheck()
    
    @State private var searchText: String = ""
    @State private var results: [String] = []
    
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        NavigationView {
            ZStack{
                
                VStack {
                    VStack(spacing: 2){
                        
                        HStack {
                            TextField("Search City", text: $searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxHeight: 40)
                            Button(action: {
                                Task{
                                    await searchCityWeather()
                                }
                            }) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20) // Adjust size as needed
                                    Text("Search")
                                        .fontWeight(.medium)
                                }
                                .padding()
                                .frame(maxWidth: 115)
                                .frame(maxHeight: 35)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .cornerRadius(8)
                            }
                            .frame(height: 40)
                        }
                        ScrollView {
                            if !networkMonitor.isConnected {
                                Text("No Internet...")
                                    .foregroundColor(.red)
                            }
                            VStack(alignment:.leading ,spacing: 5) {
                                Text("City name: \(viewModel.weatherData?.name ?? "")")
                                    .font(.headline)
                                    .padding()
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .multilineTextAlignment(.leading)
                                
                                Text("Weather: \(viewModel.weatherData?.weather?.first?.description ?? "")")
                                    .font(.headline)
                                    .padding()
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .multilineTextAlignment(.leading)
                                
                                Text(String(format: "Humidity: \(viewModel.weatherData?.main?.humidity ?? 0)%"))
                                    .font(.headline)
                                    .padding()
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .multilineTextAlignment(.leading)
                                
                                Text(String(format: "Temp: %.2f",viewModel.weatherData?.main?.temp ?? 0.0))
                                    .font(.headline)
                                    .padding()
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .multilineTextAlignment(.leading)
                                
                                Text("Visibility: \((viewModel.weatherData?.visibility ?? 0)/1000)km \n\n Wind Speed: \(viewModel.weatherData?.wind?.speed ?? 0.0)meter/sec \n\n Pressure: \(viewModel.weatherData?.main?.pressure ?? 00) hPa")
                                    .font(.headline)
                                    .padding()
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding()
                        }
                    }
                    .padding()
                    
                }.background(Color.orange.opacity(0.8))
                    .onChange(of: locationManager.cordinate) {newLatitude in viewModel.fetchWeatherData(text: "" ,lat: "\(locationManager.cordinate?.coordinate.latitude ?? 0.0)", log: "\(locationManager.cordinate?.coordinate.longitude ?? 0.0)")}
                    .navigationTitle("Weather")
                
            }
            }.onAppear {
                if let country = UserDefaults.standard.string(forKey: "country"),country != ""{
                    viewModel.fetchWeatherData(text: country)
                }else{
                    locationManager.startUpdateLocation()
                }
        }
    }
    
    private func searchCityWeather() async {
         viewModel.fetchWeatherData(text: searchText)
    }
}

#Preview {
    WeatherDetailView()
}
