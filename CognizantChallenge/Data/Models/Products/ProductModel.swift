//
//  ProductModel.swift
//  Cognizant
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

class ProductModel: Decodable {
    
    struct AdditionalInformation: Decodable {
        let overviewUrl: URL?
        let termsUrl: URL?
        let eligibilityUrl: String?
        let feesAndPricingUrl: String?
        let bundleUrl: URL?
        
        enum CodingKeys: String, CodingKey {
            case overviewUrl = "overviewUri"
            case termsUrl = "termsUri"
            case eligibilityUrl = "eligibilityUri"
            case feesAndPricingUrl = "feesAndPricingUri"
            case bundleUrl = "bundleUri"
        }
    }
    
    let identifier: String
    let effectiveFrom: Date?
    let effectiveTo: Date?
    let lastUpdated: Date
    let category: String
    let name: String
    let description: String
    let brand: String
    let brandName: String?
    let applicationUrl: URL?
    let isTailored: Bool
    let additionalInformation: AdditionalInformation
    
    enum CodingKeys: String, CodingKey {
        case identifier = "productId"
        case effectiveFrom = "effectiveFrom"
        case effectiveTo = "effectiveTo"
        case lastUpdated = "lastUpdated"
        case category = "productCategory"
        case name = "name"
        case description = "description"
        case brand = "brand"
        case brandName = "brandName"
        case applicationUrl = "applicationUri"
        case isTailored = "isTailored"
        case additionalInformation = "additionalInformation"
    }
}
