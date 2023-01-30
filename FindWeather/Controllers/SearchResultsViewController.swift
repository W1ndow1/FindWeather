//
//  SearchResultsViewController.swift
//  FindWeather
//
//  Created by window1 on 2023/02/03.
//

import UIKit

class SearchResultsViewController: UIViewController {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var currrentTemperature: UILabel!
    @IBOutlet weak var descrip: UILabel!
    @IBOutlet weak var tempMin: UILabel!
    @IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var redView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blueView.layer.cornerRadius = 10
        redView.layer.cornerRadius = 10
    }
    
    public func configure(_ cityData: WeatherResponseName) {
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(String(describing: cityData.weather[0].icon))@2x.png") else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let imageData = data else { return }
            DispatchQueue.main.async {
                let cityNameToKo = String.codeToCityName(id: cityData.id)
                self?.cityName.text = cityNameToKo.count == 0 ? cityData.name : cityNameToKo
                self?.weatherIcon.image = UIImage(data: imageData)
                self?.currrentTemperature.text = "\(String(format: "%.1f", cityData.main.temp))º"
                self?.descrip.text = cityData.weather.first?.weatherDessKo(id: (cityData.weather[0].id)) ?? ""
                self?.tempMax.text = "최고:\(String(format: "%.0f", cityData.main.tempMax))º"
                self?.tempMin.text = "최저:\(String(format: "%.0f", cityData.main.tempMin))º"
                self?.feelsLike.text = "체감기온:\(String(format: "%.0f", cityData.main.feelsLike))º"
                self?.humidity.text = "습도:\(cityData.main.humidity)%"
                self?.pressure.text = "기압:\(cityData.main.pressure)hPa"
                self?.windSpeed.text = "풍속:\(cityData.wind.speed)m/s \n (\(cityData.wind.degToString(position: cityData.wind.deg)))"
            }
        }
        .resume()
    }
}
