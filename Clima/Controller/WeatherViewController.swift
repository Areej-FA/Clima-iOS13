//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController : UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var keys: NSDictionary?
    var watherManager = WeatherManager()
    let loctionManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loctionManager.delegate = self
        loctionManager.requestWhenInUseAuthorization()
        loctionManager.requestLocation()
        
        watherManager.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func loctionPressed(_ sender: UIButton) {
        loctionManager.requestLocation()
    }
    
    
}

// MARK: - UITextFieldDelegate

extension WeatherViewController : UITextFieldDelegate{
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = " Type somthing "
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text{
            watherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController : WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager : WeatherManager ,weather: WeatherModel)  {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempertureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.ConditionName)
        }
        
    }
    
    func didFailWithError(_ error: Error){
        print(error)
    }
    
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            loctionManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            watherManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
