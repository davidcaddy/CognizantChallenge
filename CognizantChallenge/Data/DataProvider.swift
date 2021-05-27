//
//  File.swift
//  CognizantChallenge
//
//  Created by Dave Caddy on 27/5/21.
//

import Foundation

enum FetchError: Error {
    case badRequest
    case notAcceptable
    case unprocessableEntity
    case tooManyRequests
    case serverError
    case malformedResponse
    case unknown
}

protocol DataProvider {
    func fetchProducts(pageSize: Int, pageOffset: Int, completion: ((_ result: Result<ProductsResponseModel, FetchError>) -> Void)?)
    
    func fetchProductDetails(productID: String, completion: ((_ result: Result<ProductDetailsResponseModel, FetchError>) -> Void)?)
}
