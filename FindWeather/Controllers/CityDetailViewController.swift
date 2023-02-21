//
//  CityDetailViewController.swift
//  FindWeather
//
//  Created by window1 on 2023/02/03.
//

import UIKit
import MapKit
import CoreLocation

class CityDetailViewController: UIViewController {

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
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var windClock: UIImageView!
    @IBOutlet weak var windClockView: UIStackView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blueView.layer.cornerRadius = 10
        redView.layer.cornerRadius = 10
        windClockView.layer.cornerRadius = 10
        mapView.layer.cornerRadius = 10
        windClock.image = UIImage(named: "upArrow")?.withTintColor(.white)

        let cityLocation = MKPointAnnotation()
        cityLocation.coordinate = CLLocationCoordinate2D(latitude: 33.95, longitude: -117.34)
        cityLocation.title = "sample"
        cityLocation.subtitle = "subtitle"
        self.mapView.addAnnotation(cityLocation)
        
    }
    
    //TODO: - 넘어오는 방향에 맞춰 도형 회전시키기
    private func pointWindClock(with degree: Int) {
        DispatchQueue.main.async {
            self.windClock.transform = CGAffineTransform(scaleX: 2, y: 2)
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
    
    
    public func configure(with cityData: WeatherResponseName) {
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
                self?.sunset.text = "일몰:\(Date(timeIntervalSince1970: Double(cityData.sys.sunset)).toStringKST(dataFormat: "HH:mm"))"
                self?.sunrise.text = "일출:\(Date(timeIntervalSince1970: Double(cityData.sys.sunrise)).toStringKST(dataFormat: "HH:mm"))"
            }
        }
        .resume()
        pointWindClock(with: cityData.wind.deg)
        mapToPosition(lat: cityData.coord.lat, lon: cityData.coord.lon, name: cityData.name ?? "")
    }
    
}

extension CityDetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        let id  = MKMapViewDefaultAnnotationViewReuseIdentifier
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView{
            if annotation.title == "sample" {
                return view
            }
        }
        return nil
    }
}
