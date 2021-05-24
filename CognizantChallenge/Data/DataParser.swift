//
//  DataParser.swift
//  Cognizant
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

class DataParser {
    
    let decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withDashSeparatorInDate, .withColonSeparatorInTime, .withFractionalSeconds]
        let iso8601MillisFormatter = ISO8601DateFormatter()
        iso8601MillisFormatter.formatOptions = [.withDashSeparatorInDate, .withColonSeparatorInTime, .withFractionalSeconds]
        
        jsonDecoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            for formatter in [iso8601Formatter, iso8601MillisFormatter] {
                if let date = formatter.date(from: dateString) {
                    return date
                }
            }

            throw DecodingError.dataCorruptedError(in: container, debugDescription: "[DataParser] Cannot decode date string: \(dateString)")
        }
        
        return jsonDecoder
    }()
    
    func parseProducts(fromData data: Data) -> ProductsResponseModel? {
        do {
            return try self.decoder.decode(ProductsResponseModel.self, from: data)
        }
        catch let error as NSError {
            print("[DataParser] Failed parse products data: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func parseProductDetails(fromData data: Data) -> ProductDetailsResponseModel? {
        do {
            return try self.decoder.decode(ProductDetailsResponseModel.self, from: data)
        }
        catch let error as NSError {
            print("[DataParser] Failed parse product details data: \(error.localizedDescription)")
            print(error)
        }
        
        return nil
    }
}
