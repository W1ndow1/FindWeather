//
//  APICaller.swift
//  FindWeather
//
//  Created by window1 on 2023/01/31.
//

import Foundation

struct Constants{
    static let baseURL = "https://api.openweathermap.org/data/2.5/"
    static let language = "lang=kr"
    static let cityCode = """
                        1842616,1841811,1842225,1842025,1835327,\
                        1835224,1841066,1838519,1835895,1835848,\
                        1836553,1835553,1835648,1833742,1843491,\
                        1845457,1846265,1845759,1845033,1845136
                        """
}

enum NetworkError: Error {
    case badURL
    case noData
    case decodingError
    case failedToGetData
    case badQuary
}

class APICaller {
    
    static let shared = APICaller()
    
    func weatherByCityName(with query: String,  completion: @escaping (Result<WeatherResponseName, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseURL)weather?q=\(query)&appid=\(Bundle.main.APIKey)&\(Constants.language)&units=metric") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(WeatherResponseName.self, from: data)
                print(results)
                completion(.success(results))
            } catch {
                completion(.failure(NetworkError.decodingError))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func weatherByCityCode(completion: @escaping (Result<WeatherResponseCode, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)group?id=\(Constants.cityCode)&appid=\(Bundle.main.APIKey)&\(Constants.language)&units=metric") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(WeatherResponseCode.self, from: data)
                completion(.success(results))
                print(results)
            } catch {
                completion(.failure(NetworkError.decodingError))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func weatherByCityNameAsync(cityName query: String) async throws -> WeatherResponseName {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            throw NetworkError.badQuary }
        guard let url = URL(string: "\(Constants.baseURL)weather?q=\(query)&appid=\(Bundle.main.APIKey)&\(Constants.language)&units=metric") else {
            throw NetworkError.badURL }
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw NetworkError.noData }
        guard let result = try JSONDecoder().decode(WeatherResponseName?.self, from: data) else { throw NetworkError.decodingError }
        return result
    }
    
    
    func weatherByCityCodeAsync() async throws -> WeatherResponseCode {
        guard let url = URL(string: "\(Constants.baseURL)group?id=\(Constants.cityCode)&appid=\(Bundle.main.APIKey)&\(Constants.language)&units=metric") else {
            throw NetworkError.badURL }
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw NetworkError.noData }
        guard let result = try JSONDecoder().decode(WeatherResponseCode?.self, from: data) else { throw NetworkError.decodingError
            
        }
        return result
    }
    
    func fiveDayWeatherforecastAsync(lat latitude: Double, lon longtitude: Double) async throws -> WeatherForecast {
        guard let url = URL(string: "\(Constants.baseURL)forecast?lat=\(latitude)&lon=\(longtitude)&appid=\(Bundle.main.APIKey)&\(Constants.language)&units=metric") else {
            print("badURL")
            throw NetworkError.badURL
        }
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("networkError")
            throw NetworkError.noData}
        guard let result = try JSONDecoder().decode(WeatherForecast?.self, from: data) else {
            print("decodingError")
            throw NetworkError.decodingError
        }
        return result
    }
}

extension Bundle {
    var APIKey: String {
        guard let file = self.path(forResource: "WeatherInfo", ofType: "plist") else { return "" }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["API_KEY"] as? String else { fatalError("Set API_KEY to  WeatherInfo") }
        return key
    }
}
