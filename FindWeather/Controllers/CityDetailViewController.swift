//
//  CityDetailViewController.swift
//  FindWeather
//
//  Created by window1 on 2023/02/03.
//

import UIKit

class CityDetailViewController: UIViewController {

    @IBOutlet weak var forecastWeatherTableView: UITableView!
    
    private var forecastList: [ForecastList] = []
    private var cityData: WeatherResponseName?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        forwardWeatherTableViewSetup()
        
        Task {
            do{
                let forecastList = try await APICaller().fiveDayWeatherforecastAsync(lat: cityData?.coord.lat ?? 0.0, lon: cityData?.coord.lon ?? 0.0)
                self.forecastList = forecastList.list
            } catch {
                print("error")
            }
            forecastWeatherTableView.reloadData()
        }
    }

    private func forwardWeatherTableViewSetup() {

        forecastWeatherTableView.delegate = self
        forecastWeatherTableView.dataSource = self
        forecastWeatherTableView.register(UINib(nibName: "CityDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "CityDetailCell")
        forecastWeatherTableView.register(UINib(nibName: "CityDetailHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CityDetailHeaderView")
        forecastWeatherTableView.register(UINib(nibName: "LicenseFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "LicenseFooterView")
    }
    
    public func configure(with cityData: WeatherResponseName) {
        self.cityData = cityData
    }
    
}

//MARK: UITableView
extension CityDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = forecastWeatherTableView.dequeueReusableCell(withIdentifier: "CityDetailCell", for: indexPath) as? CityDetailTableViewCell else {
            return UITableViewCell()
        }
        let forecastData = forecastList[indexPath.row]
        Task {
            try await cell.configure(with:forecastData)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CityDetailHeaderView")
        return headerView?.bounds.height ?? 650
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CityDetailHeaderView") as? CityDetailHeaderView else {
            return UIView()
        }
        guard let cityData = cityData else {
            return UIView()
        }
        headerView.configure(with: cityData)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LicenseFooterView")
        return footerView?.bounds.height ?? 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LicenseFooterView") as? LicenseFooterView else { return UIView() }
        return footerView
    }
}
