//
//  InterestPlacesViewController.swift
//  FindWeather
//
//  Created by window1 on 2023/01/31.
//

import UIKit


class InterestPlacesViewController: UIViewController {
    
    @IBOutlet weak var weatherTableView: UITableView!
    private var cityList: [List] = []
    private var cityDataByName: WeatherResponseName?
    
    var filtterdArr: [List] = []
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    

override func viewDidLoad() {
    super.viewDidLoad()

    self.setupNavigationControllerUI()
    self.setupTableView()
    registerXib()
    loadWeatherData()
}
    
    private func setupTableView() {
        self.weatherTableView.delegate = self
        self.weatherTableView.dataSource = self
    }
    
    private func setupNavigationControllerUI() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "도시"

        navigationController?.navigationBar.tintColor = .gray
        navigationController?.navigationBar.barTintColor = .systemPink
    }
    
    private func loadWeatherData() {
        APICaller().weatherByCityCode(completion: { [weak self] result in
            switch result {
            case .success(let cityList):
                self?.cityList = cityList.list
                DispatchQueue.main.async {
                    self?.weatherTableView.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: "InterestPlacesTableViewCell", bundle: nil)
        weatherTableView.register(nibName, forCellReuseIdentifier: "InterestPlaceCell")
    }
}

extension InterestPlacesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.filtterdArr.count : self.cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: "InterestPlaceCell", for: indexPath) as? InterestPlacesTableViewCell else {
            return UITableViewCell()
        }
        let cityData = cityList[indexPath.row]
        if self.isFiltering {
            let filterData = filtterdArr[indexPath.row]
            cell.cityName.text = filterData.name
            cell.weatherDescription.text = filterData.weather.first?.description
            cell.configure(filterData)
        } else {
            cell.cityName.text = cityData.name
            cell.weatherDescription.text = cityData.weather.first?.description
            cell.configure(cityData)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCityName = cityList[indexPath.row]
        APICaller().weatherByCityName(with: selectedCityName.name ?? "", completion: { result in
            switch result {
            case .success(let cityDataByName):
                self.cityDataByName = cityDataByName
                DispatchQueue.main.async { [weak self] in
                    let vcPass = self?.storyboard?.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
                    vcPass.configure(WeatherResponseName(main: cityDataByName.main, wind: cityDataByName.wind, name: cityDataByName.name, weather: cityDataByName.weather, dt: cityDataByName.dt, id: cityDataByName.id))
                    self?.navigationController?.pushViewController(vcPass, animated: true)

                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
    }
}
//MARK: UISearchController
extension InterestPlacesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let inputText = searchController.searchBar.text?.lowercased() else { return }
        dump(inputText)
        self.filtterdArr = self.cityList.filter({ $0.name!.localizedStandardContains(inputText)})
        self.weatherTableView.reloadData()

    }
}

