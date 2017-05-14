//
//  ViewController.swift
//  Weather-App-2
//
//  Created by mitchell hudson on 11/12/15.
//  Copyright © 2015 mitchell hudson. All rights reserved.
//

//  Last Update 020516

// TODO: Clear initial screen, show button to load weather.
// TODO: Save weather location in NSUserDefaults
// TODO: Add SMS
// TODO: Add email
// TODO: Tweet Weather
// TODO: Email Image of Weather

// Get location for weather

import UIKit
import Social
import CoreLocation // 1 import CoreLocation

// 4 Add Persmission Keys to info plist 
// “NSLocationWhenInUseUsageDescription” or “NSLocationAlwaysUsageDescription”

// 2 Add the delegate protocol
class ViewController: UIViewController,
    CLLocationManagerDelegate,
    WeatherServiceDelegate,
    UIImagePickerControllerDelegate, // For image picker
    UINavigationControllerDelegate {   // For image picker
    
    // 3 Make a location manager
    let locationManager = CLLocationManager()
    // Make an instance of WeatherService with your OpenWeatherMap ID.
    var weatherService = WeatherService(appid: "b733d502184df5ed5133054473f60b5d")
    var weather: Weather?
    
    
    // MARK: IBOutlets
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    // MARK: IBActions
    
    // -- City Button
    
    /** Handles taps on the City button */
    
    @IBAction func cityButtonTapped(_ sender: AnyObject) {
        print("City button")
        self.getGPSLocation()
    }
    
    
    // MARK: Location 
    /** Get the GPS location.  */
    func getGPSLocation() {
        print("Starting location Manager")
        locationManager.startUpdatingLocation()
    }
    
    
    /** Handles location updates. Use this to get the weather for the current location. */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did update locations")
        print(locations)
        self.weatherService.getWeatherForLocation(locations[0])
        locationManager.stopUpdatingLocation()
    }
    
    /** Handle error messages from the location manager. */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error \(error) \(String(describing: error._userInfo))")
    }
    
    // MARK: WeatherService Delegate methods
    /** Handles error message from Weather Service instance. */
    func weatherErrorWithMessage(_ message: String) {
        let alert = UIAlertController(title: "Weather Service Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    /**  */
    func setWeather(_ weather: Weather) {
        let numberFormatter = NumberFormatter()
        self.descriptionLabel.text = weather.description
        
        self.tempLabel.text = numberFormatter.string(from: NSNumber(value:weather.tempF))!
        self.humidityLabel.text = "Humidity: \(numberFormatter.string(from: NSNumber(value:weather.humidity))!)%"
        self.windLabel.text = "Wind: \(numberFormatter.string(from: NSNumber(value:weather.windSpeed))!)mph"
        self.iconImageView.image = UIImage(named: weather.icon)
        print("icon:"+weather.icon)
        self.cityButton.setTitle(weather.cityName, for: UIControlState())
        
        self.weather = weather
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weatherService.delegate = self
        
        
        // 5 Set delegate and authorization
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension UIView {
    func takeScreenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}





