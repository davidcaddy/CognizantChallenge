//
//  DataParser.swift
//  Cognizant
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

class DataParser: DataParsing {
    
    let decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withDashSeparatorInDate, .withColonSeparatorInTime, .withFractionalSeconds]
        
        jsonDecoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            if let date = iso8601Formatter.date(from: dateString) {
                return date
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
        }
        
        return nil
    }
}
