//
//  WeatherManager.swift
//  Clima
//
//  Created by Areej on 2/20/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=\(ApiKey)&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        print(urlString)
        preformRequst(urlString:urlString)
    }
    
    func preformRequst(urlString: String)  {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: url) { (data, respons, error) in
                print("handle")
                if error != nil {
                    print("\(error!)")
                    return
                }
                
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString!)
                    self.parseJSON(weatherData: safeData)
                }
            }
            
            print("preformRequst")
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperture: temp)
            print(weather.ConditionName)
            
        } catch {
            print(error)
        }
    }
    
   
    
}
