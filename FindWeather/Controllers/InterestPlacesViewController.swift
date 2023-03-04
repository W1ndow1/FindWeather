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
    private var searchResultsTableViewController: SearchResultsViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerXib(tableView: weatherTableView)
        setupSearchControllerUI()
        setupTableView()
        
        Task {
            await loadWeatherDataAsync()
        }
    }
    
    private func setupTableView() {
        self.weatherTableView.delegate = self
        self.weatherTableView.dataSource = self
    }
    
    private func setupSearchControllerUI() {
        searchResultsTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultsViewController") as? SearchResultsViewController
        
        let searchController = UISearchController(searchResultsController: searchResultsTableViewController)
        searchController.searchBar.placeholder = "도시명칭(영어)"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        navigationItem.title = "도시"
        
        navigationController?.navigationBar.tintColor = .gray
        navigationController?.navigationBar.barTintColor = .systemPink
    }
    
    private func loadWeatherDataAsync() async {
        do{
            let cityList = try await APICaller().weatherByCityCodeAsync()
            self.cityList = cityList.list
            weatherTableView.reloadData()
        }
        catch{
            print(error.localizedDescription)
        }
    }

    public func registerXib(tableView: UITableView) {
        let nibName = UINib(nibName: "InterestPlacesTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "InterestPlaceCell")
    }
}

//MARK: UITableView
extension InterestPlacesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: "InterestPlaceCell", for: indexPath) as? InterestPlacesTableViewCell else {
            return UITableViewCell()
        }
        let cityData = cityList[indexPath.row]
        cell.cityName.text = cityData.name
        cell.weatherDescription.text = cityData.weather.first?.description
        cell.configure(cityData)
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
                    let vcPass = self?.storyboard?.instantiateViewController(withIdentifier: "CityDetailViewController") as! CityDetailViewController
                    vcPass.configure(with: cityDataByName)
                    self?.navigationController?.pushViewController(vcPass, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
}
//MARK: UISearchController
extension InterestPlacesViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let inputText = searchController.searchBar.text,
              !inputText.trimmingCharacters(in: .whitespaces).isEmpty,
              inputText.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        resultsController.searchDelegate = self

        APICaller().weatherByCityName(with: inputText) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cityDataByName):
                    print(cityDataByName.name ?? "")
                    resultsController.cityData = cityDataByName
                    resultsController.searchResultTableView.reloadData()

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func searchResultsViewControllerDidTapItem(with viewModel: WeatherResponseName) {
        DispatchQueue.main.async { [weak self] in
            let viewController = self?.storyboard?.instantiateViewController(withIdentifier: "CityDetailViewController") as! CityDetailViewController
            viewController.configure(with: viewModel)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

