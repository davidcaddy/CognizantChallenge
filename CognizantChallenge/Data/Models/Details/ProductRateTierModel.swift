//
//  ProductRateTierModel.swift
//  CognizantChallenge
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

struct ProductRateTierModel: Decodable {
    
    struct BankingProductRateCondition: Decodable {
        let additionalValue: String?
        let additionalInfo: String?
        let additionalInfoUrl: URL?
        
        enum CodingKeys: String, CodingKey {
            case additionalValue = "additionalValue"
            case additionalInfo = "additionalInfo"
            case additionalInfoUrl = "additionalInfoUri"
        }
    }
    
    enum RateApplicationMethod: String, Decodable {
        case dollar = "WHOLE_BALANCE"
        case percent = "PER_TIER"
    }
    
    enum UnitOfMeasure: String, Decodable {
        case dollar = "DOLLAR"
        case percent = "PERCENT"
        case month = "MONTH"
        case day = "DAY"
    }
    
    let name: String
    let unitOfMeasure: UnitOfMeasure
    let minimumValue: Double
    let maximumValue: Double
    let rateApplicationMethod: RateApplicationMethod?
    let applicabilityConditions: BankingProductRateCondition?
}
