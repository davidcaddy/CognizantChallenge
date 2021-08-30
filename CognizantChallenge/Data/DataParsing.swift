//
//  DataParsing.swift
//  CognizantChallenge
//
//  Created by David Caddy on 30/8/21.
//

import Foundation

protocol DataParsing {
    func parseProducts(fromData data: Data) -> ProductsResponseModel?
    func parseProductDetails(fromData data: Data) -> ProductDetailsResponseModel?
}
