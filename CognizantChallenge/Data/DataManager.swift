//
//  DataManager.swift
//  Cognizant
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    private let parser = DataParser()
    
    private let BASE_URL = "https://api.commbank.com.au/public/cds-au/v1/banking"
    private let PRODUCTS_URI = "/products"
    
    private let accessQueue = DispatchQueue(label: "SynchronizedArrayAccess")
    private var activeTasks: [UUID: URLSessionDataTask] = [:]
    
    private let requiredHeaders = ["x-v": "2"]
    
    private init() {
    }
    
    func fetchProducts(completion: ((_ reponse: ProductsResponseModel?) -> Void)?) {
        if let productsUrl = URL(string: "\(BASE_URL)\(PRODUCTS_URI)") {
            _ = fetchData(atUrl: productsUrl, headers: self.requiredHeaders) { (data) in
                if let responseData = data {
                    completion?(self.parser.parseProducts(fromData: responseData))
                    return
                }
                completion?(nil)
            }
        }
    }
    
    func fetchProductDetails(productID: String, completion: ((_ reponse: ProductDetailsResponseModel?) -> Void)?) {
        if let detailsUrl = URL(string: "\(BASE_URL)\(PRODUCTS_URI)/\(productID)") {
            _ = fetchData(atUrl: detailsUrl, headers: self.requiredHeaders) { (data) in
                if let responseData = data {
                    completion?(self.parser.parseProductDetails(fromData: responseData))
                    return
                }
                completion?(nil)
            }
        }
    }
    
    func fetchData(atUrl url: URL, headers: [String: String]? = nil, completion: ((_ data: Data?) -> Void)?) -> UUID {
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
