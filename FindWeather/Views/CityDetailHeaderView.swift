//
//  CityDetailHeaderView.swift
//  FindWeather
//
//  Created by ChangwonKim on 2023/02/27.
//

import UIKit
import MapKit

class CityDetailHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currrentTemperature: UILabel!
    @IBOutlet weak var descrip: UILabel!
    @IBOutlet weak var tempMin: UILabel!
    @IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var windClock: UIImageView!
    @IBOutlet weak var windClockView: UIStackView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(with cityData: WeatherResponseName ) {
        guard let url = URL(string: "http://openweathermap.org/img/wn\(String(describing: cityData.weather[0].icon))@2x.png") else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            guard let imageData = data else { return }
            DispatchQueue.main.async {
                let cityNameToKorea = String().codeToCityName(id: cityData.id)
                self?.weatherIcon.image = UIImage(data: imageData)
                self?.cityName.text = cityNameToKorea.count == 0 ? cityData.name : cityNameToKorea
                self?.currrentTemperature.text = "\(String(format: "%.1f", cityData.main.temp))º"
                self?.descrip.text = cityData.weather[0].weatherDessKo(id: cityData.weather[0].id)
                self?.tempMax.text = "최고:\(String(format: "%.0f", cityData.main.tempMax))º"
                self?.tempMin.text = "최저:\(String(format: "%.0f", cityData.main.tempMin))º"
                self?.feelsLike.text = "체감기온:\(String(format: "%.0f", cityData.main.feelsLike))º"
                self?.humidity.text = "습도:\(cityData.main.humidity)%"
                self?.pressure.text = "기압:\(cityData.main.pressure)hPa"
                self?.windSpeed.text = "풍속:\(cityData.wind.speed)m/s \n (\(cityData.wind.degToString(position: cityData.wind.deg)))"
                self?.sunset.text = "일몰:\(Date(timeIntervalSince1970: Double(cityData.sys.sunset)).toStringKST(dataFormat: "HH:mm"))"
                self?.sunrise.text = "일출:\(Date(timeIntervalSince1970: Double(cityData.sys.sunrise)).toStringKST(dataFormat: "HH:mm"))"
            }
        })
    }
}
