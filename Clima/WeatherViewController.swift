//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeSettingDelegate{
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    
    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
   
    var tempDate = ""
    var tempDate2 = ""
    //the variables to store the sunset and sunrise time
    
    
    //IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Setting up the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(url : String, parameters : [String:String]) {
        Alamofire.request(url, method : .get, parameters : parameters).responseJSON {
            response in
            if response.result.isSuccess {
        
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            }
            else{
                self.cityLabel.text = "Connection Issues"
            }
        }
        
    }
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateWeatherData method here:
    
    //This is the function to convert unix time to current time
    func getDate(unixdate: Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixdate))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return "\(dateString)"
        
    }
    
    func updateWeatherData(json: JSON){
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - 237.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition:weatherDataModel.condition)
            //this code parses the JSON file to search for the temperature (in kelvins)
        }
        else {
            cityLabel.text = "Weather Unavailable"
        }
        
        weatherDataModel.sunrise = json["sys"]["sunrise"].intValue
        weatherDataModel.sunset = json["sys"]["sunset"].intValue
        //this code parses the JSON file to search for the sunrise and sunset times
        

   tempDate = getDate(unixdate: weatherDataModel.sunrise)
      print(tempDate)
     sunriseLabel.text = tempDate
    //converting sunrise unix time to current time
        
        
       
    tempDate2 = getDate(unixdate: weatherDataModel.sunset)
        print(tempDate2)
        sunsetLabel.text = tempDate2
      //converting sunset unix time to current time
        
        
        updateUIWithWeatherData()
    }
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
   //this is the function that updates the labels that display the city and temperature
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIcon.image = UIImage(named:weatherDataModel.weatherIconName)
    }
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
        }
        print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        let params : [String:String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    
    
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCityName(city: String) {
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    //this is the function that updates the sunrise sunset times based on whether the toggle is on or off
    func userToggled(isToggled : String) {
        if isToggled == "isOn"{
            sunriseLabel.text = tempDate
            sunsetLabel.text = tempDate2
            //if toggle is on, the labels should display tempDate or tempDate2
        }
        if isToggled == "isOff"{
            sunriseLabel.text = ""
            sunsetLabel.text = ""
            // if toggle is off, the label should be empty
        }
    }
    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        
        }
    }
}

