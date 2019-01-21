//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Zin Min Phyoe on 1/21/19.
//  Copyright © 2019 Zin Min Phyoe. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var timeFormatLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var seasonConditionLabel: UILabel!
    @IBOutlet var seasonConditionImage: UIImageView!
    @IBOutlet var windRateLabel: UILabel!
    @IBOutlet var rainLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var cityNameTextFirld: UITextField!
    @IBOutlet var backgroundWeatherImage: UIImageView!
    
    let apiKey = "fb965f16edf69e67f8d1e042972b5fdd"
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?q="
    
    @IBAction func searchCityName(_ sender: UIButton) {
        cityNameTextFirld.isHidden = false
    }
    @IBAction func textFieldtriggered(_ sender: Any) {
        getWeatherInfo(cityNameTextFirld.text ?? "Yangon")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityNameTextFirld.delegate = self
        let searcHCityName = "Yangon"
        getWeatherInfo(searcHCityName)
        cityNameTextFirld.isHidden = true
    }

    
    func getWeatherInfo(_ cityName:String){
        let url = baseURL+cityName+"&appid="+apiKey
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let request = URLRequest(url: URL(string: url)!)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Unknown Error")
            }else if let data = data {
                let weatherDict = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                
                print(weatherDict)
                
                //Wind Rate
                let wind = weatherDict["wind"] as! [String:Double]
                let windSpeed = wind["speed"]
                
                
                //Main (humidity,temperature ...)
                let main = weatherDict["main"] as! [String:Double]
                let humidity = main["humidity"]
                let temperature = main["temp"] as! Double
                let celciusTemp = temperature - 273.15
                let celciusTempInt = Int(celciusTemp)
                let weather = weatherDict["weather"] as! [[String:Any]]
                let descriptionWeather = weather[0]
                let description = descriptionWeather["main"] as! String
                
                
               
                
                //Weather
                let cityName = weatherDict["name"] as! String
                
                OperationQueue.main.addOperation {
                    self.humidityLabel.text = String(humidity ?? 0.0)
                    self.windRateLabel.text = String(windSpeed ?? 0.0)
                    self.cityNameLabel.text = String(cityName)
                    self.temperatureLabel.text = String("\(celciusTempInt)°C")
                    if description == "Haze"{
                        UIView.animate(withDuration: 2.0, animations: {
                            self.backgroundWeatherImage.alpha = 1.0
                            self.backgroundWeatherImage.image = UIImage(named: "185168.jpg")
                            
                        })
                    }else if description == "Clouds" {
                        self.backgroundWeatherImage.image = UIImage(named: "cloudy.jpg")
                    }
                }
            }
        }
        task.resume()
    }

}

