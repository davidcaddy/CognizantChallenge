//
//  ProductBundleModel.swift
//  CognizantChallenge
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

struct ProductBundleModel: Decodable {
    
    let name: String
    let description: String
    let additionalInfo: String?
    let additionalInfoUrl: URL?
    let productIDs: [String]
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case additionalInfo = "additionalInfo"
        case additionalInfoUrl = "additionalInfoUri"
        case productIDs = "productIds"
    }
}
