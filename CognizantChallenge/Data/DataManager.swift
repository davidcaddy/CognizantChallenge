//
//  DataManager.swift
//  Cognizant
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

class DataManager: DataProvider {
    
    private let parser: DataParsing
    
    private let BASE_URL = "https://api.commbank.com.au/public/cds-au/v1/banking"
    private let PRODUCTS_PATH = "/products"
    
    private let accessQueue = DispatchQueue(label: "SynchronizedArrayAccess")
    
    init(dataParser: DataParsing = DataParser()) {
        self.parser = dataParser
    }
    
    func fetchProducts(pageSize: Int, pageOffset: Int, completion: ((_ result: Result<ProductsResponseModel, FetchError>) -> Void)?) {
        var productsURL = URLComponents(string: "\(BASE_URL)\(PRODUCTS_PATH)")
        productsURL?.queryItems = [
            URLQueryItem(name: "page-size", value: String(pageSize)),
            URLQueryItem(name: "page", value: String(pageOffset))
        ]
        if let url = productsURL?.url {
            let requiredHeaders = ["Accept": "application/json", "x-v": "3"]
            fetchData(atURL: url, headers: requiredHeaders) { (data) in
                if let responseData = data, let response = self.parser.parseProducts(fromData: responseData) {
                    completion?(.success(response))
                    return
                }
                completion?(.failure(.malformedResponse))
            }
        }
    }
    
    func fetchProductDetails(productID: String, completion: ((_ result: Result<ProductDetailsResponseModel, FetchError>) -> Void)?) {
        if let detailsURL = URL(string: "\(BASE_URL)\(PRODUCTS_PATH)/\(productID)") {
            let requiredHeaders = ["Accept": "application/json", "x-v": "4"]
            fetchData(atURL: detailsURL, headers: requiredHeaders) { (data) in
                if let responseData = data, let response = self.parser.parseProductDetails(fromData: responseData) {
                    completion?(.success(response))
                    return
                }
                completion?(.failure(.malformedResponse))
            }
        }
    }
    
    private func fetchData(atURL url: URL, headers: [String: String]? = nil, completion: ((_ data: Data?) -> Void)?) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let injectedHeaders = headers {
            for (key, value) in injectedHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            completion?(data)
        }
        
        dataTask.resume()
    }
}
