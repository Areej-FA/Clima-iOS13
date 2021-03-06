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
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, respons, error) in
                print("handle")
                if error != nil {
                    print("\(error!)")
                    return
                }
                
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString)
                    self.parseJSON(weatherData: safeData)
                }
            }
            print("preformRequst")
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        <#function body#>
    }
    
}
