//
//  CityDetailHeaderView.swift
//  FindWeather
//
//  Created by window1 on 2023/02/27.
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        blueView.layer.cornerRadius = 10
        redView.layer.cornerRadius = 10
        windClockView.layer.cornerRadius = 10
        mapView.layer.cornerRadius = 10
        windClock.image = UIImage(named: "upArrow")?.withTintColor(.white)

    }
    
    
    private func pointWindClock(with degree: Int) {
        DispatchQueue.main.async {
            self.windClock.transform = CGAffineTransform(rotationAngle: CGFloat(degree))
        }
    }
    
    private func mapToPosition(lat latitude: Double, lon longitude: Double, name cityName: String ) {
        DispatchQueue.main.async {
            let cityLocation = CLLocationCoordinate2DMake(latitude, longitude)
            let pSpanValue = MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)
            let pRegion = MKCoordinateRegion(center: cityLocation, span: pSpanValue)
            self.mapView.setRegion(pRegion, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = cityLocation
            annotation.title = cityName
            self.mapView.addAnnotation(annotation)
        }
    }
    
    
    public func configure(with cityData: WeatherResponseName ) {
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(String(describing: cityData.weather[0].icon))@2x.png") else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let imageData = data else { return }
            DispatchQueue.main.async {
                self.weatherIcon.image = UIImage(data: imageData)
            }
        })
        .resume()
        let cityNameToKorea = String().codeToCityName(id: cityData.id)
        cityName.text = cityNameToKorea.count == 0 ? cityData.name : cityNameToKorea
        currrentTemperature.text = "\(String(format: "%.1f", cityData.main.temp))º"
        descrip.text = cityData.weather[0].weatherDessKo(id: cityData.weather[0].id)
        tempMax.text = "최고:\(String(format: "%.0f", cityData.main.tempMax))º"
        tempMin.text = "최저:\(String(format: "%.0f", cityData.main.tempMin))º"
        feelsLike.text = "체감기온:\(String(format: "%.0f", cityData.main.feelsLike))º"
        humidity.text = "습도:\(cityData.main.humidity)%"
        pressure.text = "기압:\(cityData.main.pressure)hPa"
        windSpeed.text = "풍속:\(cityData.wind.speed)m/s \n (\(cityData.wind.degToString(position: cityData.wind.deg)))"
        sunset.text = "일몰:\(Date(timeIntervalSince1970: Double(cityData.sys.sunset)).toStringKST(dataFormat: "HH:mm"))"
        sunrise.text = "일출:\(Date(timeIntervalSince1970: Double(cityData.sys.sunrise)).toStringKST(dataFormat: "HH:mm"))"
        pointWindClock(with: cityData.wind.deg)
        mapToPosition(lat: cityData.coord.lat, lon: cityData.coord.lon, name: cityData.name ?? "")
   
    }
}
