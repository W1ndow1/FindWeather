//
//  InterestPlacesTableViewCell.swift
//  FindWeather
//
//  Created by window1 on 2023/02/02.
//

import UIKit

class InterestPlacesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var currentHumidity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func configure(_ cityData: List) {
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(String(describing: cityData.weather[0].icon))@2x.png") else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let imageData = data else { return }
            DispatchQueue.main.async {
                self?.weatherIcon.image = UIImage(data: imageData)
            }
        }
        .resume()
        currentTemperature.text = "\(cityData.main.temp)℃"
        currentHumidity.text = "\(cityData.main.humidity)%"
    }
    public func configure(with model: WeatherResponseName) {
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(String(describing: model.weather[0].icon))@2x.png") else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            guard let imageData = data else { return }
            DispatchQueue.main.async {
                self?.weatherIcon.image = UIImage(data: imageData)
            }
        })
        .resume()
    }
    public func configureAsync(with model: WeatherResponseName) async throws -> Void {
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(String(describing: model.weather[0].icon))@2x.png") else { return }
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }
        guard let imageData = UIImage(data: data) else { return }
        weatherIcon.image = imageData
    }

}
