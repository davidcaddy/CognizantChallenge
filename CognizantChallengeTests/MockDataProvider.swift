//
//  MockDataProvider.swift
//  CognizantChallengeTests
//
//  Created by Dave Caddy on 27/5/21.
//

import Foundation
@testable import CognizantChallenge

class MockDataProvider: DataProvider {
    
    private let productsResponsePage1: Result<ProductsResponseModel, FetchError>
    private let productsResponsePage2: Result<ProductsResponseModel, FetchError>
    private let productDetailsResponse: Result<ProductDetailsResponseModel, FetchError>
    
    init() {
        let fileLoader = FileLoader()
        let dataParser = DataParser()
        
        if let data = fileLoader.loadData(fromFileAtPath: Bundle(for: type(of: self)).path(forResource: "MockDataPage1", ofType: "json")) {
            if let productsResponse = dataParser.parseProducts(fromData: data) {
                self.productsResponsePage1 = .success(productsResponse)
            }
            else {
                self.productsResponsePage1 = .failure(FetchError.malformedResponse)
            }
        }
        else {
            self.productsResponsePage1 = .failure(FetchError.serverError)
        }
        
        if let data = fileLoader.loadData(fromFileAtPath: Bundle(for: type(of: self)).path(forResource: "MockDataPage2", ofType: "json")) {
            if let productsResponse = dataParser.parseProducts(fromData: data) {
                self.productsResponsePage2 = .success(productsResponse)
            }
            else {
                self.productsResponsePage2 = .failure(FetchError.malformedResponse)
            }
        }
        else {
            self.productsResponsePage2 = .failure(FetchError.serverError)
        }
        
        if let data = fileLoader.loadData(fromFileAtPath: Bundle(for: type(of: self)).path(forResource: "MockProductDetails", ofType: "json")) {
            if let productDetailsResponse = dataParser.parseProductDetails(fromData: data) {
                self.productDetailsResponse = .success(productDetailsResponse)
            }
            else {
                self.productDetailsResponse = .failure(FetchError.malformedResponse)
            }
        }
        else {
            self.productDetailsResponse = .failure(FetchError.serverError)
        }
    }
    
    func fetchProducts(pageSize: Int, pageOffset: Int, completion: ((Result<ProductsResponseModel, FetchError>) -> Void)?) {
        if ((pageSize < 1) || (pageOffset < 1)) {
            completion?(.failure(FetchError.unprocessableEntity))
        }
        else if (pageOffset == 1) {
            completion?(self.productsResponsePage1)
        }
        else if (pageOffset == 1) {
            completion?(self.productsResponsePage2)
        }
        else {
            completion?(.failure(.unknown))
        }
    }
    
    func fetchProductDetails(productID: String, completion: ((Result<ProductDetailsResponseModel, FetchError>) -> Void)?) {
        switch self.productDetailsResponse {
        case .success(let response):
            if (response.product.identifier == productID) {
                completion?(self.productDetailsResponse)
            }
            else {
                completion?(.failure(FetchError.badRequest))
            }
        case .failure(_):
            completion?(self.productDetailsResponse)
        }
    }
}
