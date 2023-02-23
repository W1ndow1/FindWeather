//
//  CityDetailTableViewCell.swift
//  FindWeather
//
//  Created by ChangwonKim on 2023/02/23.
//

import UIKit

class CityDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempMin: UILabel!
    @IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var forecastTime: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configureAsync(with model: ForecastList) async throws -> Void {
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(String(describing: model.weather[0].icon))@2x.png") else { return }
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }
        guard let imageData = UIImage(data: data) else { return }
        weatherIcon.image = imageData
        tempMin.text = "최소:\(model.main.tempMin)"
        tempMax.text = "최대:\(model.main.tempMax)"
        forecastTime.text = "\(Date(timeIntervalSince1970: Double(model.dt)).toStringKST(dataFormat: "MM/dd HH:mm"))"
        currentTemp.text = "체감온도:\(model.main.feelsLike)"
        
    }
    
}
