//
//  StoreManager.swift
//  FoodFinder IOS14
//
//  Created by Matias Rojas Zuñiga on 12/11/2020.
//

import Foundation
import CoreLocation

protocol StoreManagerDelegate {
    func didUpdateStore(_ storeManager: StoreManager, _ store: StoreModel)
    func didFailWithError(error: Error)
}

struct StoreManager {
    let apiURL = "http://localhost:3000/api/v1"
    var delegate: StoreManagerDelegate?
    
    func fetchStore() {
        let urlString = "\(apiURL)/stores"
        perfomRequest(with: urlString)
    }
    
//    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
//        perfomRequest(with: urlString)
//    }
    
    func perfomRequest(with url: String){
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    print(error!)
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let store = self.parseJSON(safeData) {
                        delegate?.didUpdateStore(self, store)
                    }
                }
            }
            task.resume()
        }
    }

    func parseJSON(_ storeData: Data) -> StoreModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(StoreData.self, from: storeData)
            let name = decodedData.name
            let country = decodedData.country
            let lat = Double(decodedData.latitude)!
            let lon = Double(decodedData.longitude)!
            let store = StoreModel(name: name, country: country, latitude: lat, longitude: lon)
            return store
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
