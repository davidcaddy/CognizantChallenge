//
//  DataManager.swift
//  Cognizant
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

class DataManager: DataProvider {
    
    static let shared = DataManager()
    
    private let parser = DataParser()
    
    private let BASE_URL = "https://api.commbank.com.au/public/cds-au/v1/banking"
    private let PRODUCTS_URI = "/products"
    
    private let accessQueue = DispatchQueue(label: "SynchronizedArrayAccess")
    private var activeTasks: [UUID: URLSessionDataTask] = [:]
    
    private let requiredHeaders = ["Accept": "application/json", "x-v": "2"]
    
    private init() {
    }
    
    func fetchProducts(pageSize: Int, pageOffset: Int, completion: ((_ result: Result<ProductsResponseModel, FetchError>) -> Void)?) {
        var productsURL = URLComponents(string: "\(BASE_URL)\(PRODUCTS_URI)")
        productsURL?.queryItems = [
            URLQueryItem(name: "page-size", value: String(pageSize)),
            URLQueryItem(name: "page", value: String(pageOffset))
        ]
        if let url = productsURL?.url {
            _ = fetchData(atURL: url, headers: self.requiredHeaders) { (data) in
                if let responseData = data, let response = self.parser.parseProducts(fromData: responseData) {
                    completion?(.success(response))
                    return
                }
                completion?(.failure(.malformedResponse))
            }
        }
    }
    
    func fetchProductDetails(productID: String, completion: ((_ result: Result<ProductDetailsResponseModel, FetchError>) -> Void)?) {
        if let detailsURL = URL(string: "\(BASE_URL)\(PRODUCTS_URI)/\(productID)") {
            _ = fetchData(atURL: detailsURL, headers: self.requiredHeaders) { (data) in
                if let responseData = data, let response = self.parser.parseProductDetails(fromData: responseData) {
                    completion?(.success(response))
                    return
                }
                completion?(.failure(.malformedResponse))
            }
        }
    }
    
    func fetchData(atURL url: URL, headers: [String: String]? = nil, completion: ((_ data: Data?) -> Void)?) -> UUID {
        let identifier = UUID()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let injectedHeaders = headers {
            for (key, value) in injectedHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            self.removeTaskFromActiveList(withIdentifier: identifier)
            completion?(data)
        }
        
        addTaskToActiveList(task: dataTask, identifier: identifier)
        dataTask.resume()
        
        return identifier
    }
    
    func cancelFetch(withId identifier: UUID) {
        self.accessQueue.sync {
            self.activeTasks[identifier]?.cancel()
            self.activeTasks.removeValue(forKey: identifier)
        }
    }
    
    // MARK: Helper Methods
    
    private func addTaskToActiveList(task: URLSessionDataTask, identifier: UUID) {
        self.accessQueue.async(flags: .barrier) { [weak self] in
            self?.activeTasks[identifier] = task
        }
    }
    
    private func removeTaskFromActiveList(withIdentifier identifier: UUID) {
        self.accessQueue.async(flags: .barrier) { [weak self] in
            self?.activeTasks.removeValue(forKey: identifier)
        }
    }
}
