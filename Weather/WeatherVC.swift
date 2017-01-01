//
//  WeatherVC.swift
//  Weather
//
//  Created by OMER BUKTE on 12/31/16.
//  Copyright © 2016 Omer Bukte. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class WeatherVC: UIViewController, UITableViewDataSource,UITableViewDelegate, CLLocationManagerDelegate {
   


    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather = CurrentWeather()
    var forecast: Forecast!
    var forecasts = [Forecast]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        currentWeather = CurrentWeather()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            if currentLocation != nil {
                locationManager.stopUpdatingLocation()
            }
            Location.sharedInstance.latitude = currentLocation?.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation?.coordinate.longitude
            print("Lat :=: \(currentLocation?.coordinate.latitude) and Long :=: \(currentLocation?.coordinate.longitude)")
           currentWeather.downloadWeatherDetails {
                self.downloadForecastData {
                    self.updateMainUI()
                    self.tableView.reloadData()
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
  
    func downloadForecastData(completed: @escaping DownloadComplete){
        
        Alamofire.request(FORECAST_URL).responseJSON { response in
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String,AnyObject> {
                
                if let list = dict["list"] as? [Dictionary<String,AnyObject>]{
                    
                    for obj in list {
                        
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                    }
                    self.forecasts.remove(at: 0)
                    self.tableView.reloadData()
                }
                
            }
           completed()
        }
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
            "weatherCell", for: indexPath) as? WeatherCell {
            
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            
            return cell
        }else {
            
            return  WeatherCell()
        }
    }
    
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }

}

