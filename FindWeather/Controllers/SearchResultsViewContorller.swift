//
//  SearchResultsVIewContorller.swift
//  FindWeather
//
//  Created by window1 on 2023/02/03.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(with viewModel: WeatherResponseName)
}


class SearchResultsViewController: UIViewController {
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    public var searchDelegate: SearchResultsViewControllerDelegate?
    
    public var cityData: WeatherResponseName?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerXib()
        
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: "InterestPlacesTableViewCell", bundle: nil)
        searchResultTableView.register(nibName, forCellReuseIdentifier: "InterestPlaceCell")
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InterestPlaceCell", for: indexPath) as? InterestPlacesTableViewCell else {
            return UITableViewCell()
        }
        let cityData = cityData
        cell.cityName.text = cityData?.name
        cell.currentHumidity.text = "\(cityData?.main.humidity ?? 0)%"
        cell.currentTemperature.text = "\(cityData?.main.temp ?? 0)℃"
        cell.weatherDescription.text = "\(cityData?.weather[0].description ?? "")"
        if cityData != nil { cell.configure(with: cityData!) }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCityData = cityData
        APICaller().weatherByCityName(with: selectedCityData?.name ?? "", completion: { [weak self] result in
            switch result {
            case .success(let result):
                self?.cityData = result
                DispatchQueue.main.async {
                    self?.searchDelegate?.searchResultsViewControllerDidTapItem(with: result)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
