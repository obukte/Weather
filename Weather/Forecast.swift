//
//  Forecast.swift
//  Weather
//
//  Created by OMER BUKTE on 1/1/17.
//  Copyright © 2017 Omer Bukte. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    
    
    var _date: String!
    var _weatherType: String!
    var _highTemp: String!
    var _lowTemp: String!
    
    
    var date: String {
        if _date == nil{
            _date = ""
        }
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var highTemp: String {
        if _highTemp == nil{
            _highTemp = ""
        }
        return _highTemp
    }
    
    var lowTemp: String {
        if _lowTemp == nil{
            _lowTemp = ""
        }
        return _lowTemp
    }
    
    init (weatherDict: Dictionary<String, AnyObject>){
        
        if let temp = weatherDict["temp"] as? Dictionary <String,AnyObject>{
            
            if let min = temp["min"] as? Double{
                let kelvinToCelciusPreDevision = (min - 273.15)
                let kelvinToCelcius = Double(round(10 * kelvinToCelciusPreDevision/10))
                self._lowTemp = "\(kelvinToCelcius)"
            }
            if let max = temp["max"] as? Double{
                let kelvinToCelciusPreDevision = (max - 273.15)
                let kelvinToCelcius = Double(round(10 * kelvinToCelciusPreDevision/10))
                self._highTemp = "\(kelvinToCelcius)"
            }
            
        }
        
        if let weather = weatherDict["weather"] as? [Dictionary<String,AnyObject>] {
            
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
        }
        if let date = weatherDict["dt"] as? Double{
            
            let unixCorvertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
            self._date = unixCorvertedDate.dayOfTheWeek()
        }
    }
    
}

extension Date {
    func dayOfTheWeek() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
