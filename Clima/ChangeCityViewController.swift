//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit


//Write the protocol declaration here:
protocol ChangeSettingDelegate {
    func userEnteredANewCityName(city: String)

    func userToggled(isToggled : String)
    //this function in the protocol allows the changeCityViewController to pass information through the delegate
}

class ChangeCityViewController: UIViewController {
    
    var featureOnOrOff = ""
    //this variable keeps track of whether the toggle is on or off. This will be used when changeCityViewController passes information to the weatherViewController
    
    //Declare the delegate variable here:
    var delegate : ChangeSettingDelegate?
    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        //1 Get the city name the user entered in the text field
        let cityName = changeCityTextField.text!
        
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        delegate?.userEnteredANewCityName(city: cityName)
        
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func toggleSunriseSunset(_ sender: UISwitch) {
        if (sender.isOn == true){
            featureOnOrOff = "isOn"
            delegate?.userToggled(isToggled: featureOnOrOff)
        //if the toggle is on, we should call a method on the delegate to alert the weatherViewController to display sunrise/sunset times. featureOnorOff keeps track of whether the toggle is on or off
        }else{
            featureOnOrOff = "isOff"
            delegate?.userToggled(isToggled: featureOnOrOff)
        //if the toggle is off,we should call a method on the delegate to alert the weatherViewController to not display sunrise/sunset times.
       
        }
    }
    

    //when the user taps the back button, this function dismisses the ChangeCityViewController.
   @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    
    }
    

}
