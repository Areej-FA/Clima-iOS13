//
//  WeatherManager.swift
//  Clima
//
//  Created by Areej on 2/20/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager : WeatherManager ,weather: WeatherModel)
    func didFailWithError(_ error : Error)
}

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=\(ApiKey)&units=metric"
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName : String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
//        print(urlString)
        preformRequst(urlString)
    }
    
    func preformRequst(_ urlString : String)  {
        if let url = URL(string : urlString){
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with : url) { (data, respons, error) in
//                print("handle")
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
//            print("preformRequst")
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData : Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from : weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(conditionId : id, cityName : name, temperture : temp)
//            print(weather.ConditionName)
//            print(weather.tempertureString)
            return weather
            
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
    
   
    
}
