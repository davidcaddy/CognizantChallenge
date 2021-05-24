//
//  ProductRateDepositModel.swift
//  CognizantChallenge
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

struct ProductRateDepositModel: Decodable {
    
    enum DepositRateType: String, Decodable {
        case standard = "STANDARD"
        case fixed = "FIXED"
        case bonus = "BONUS"
        case bundleBonus = "BUNDLE_BONUS"
        case variable = "VARIABLE"
        case introductory = "INTRODUCTORY"
        case floating = "FLOATING"
        case marketLinked = "MARKET_LINKED"
    }
    
    let type: DepositRateType
    let rate: String
    let calculationFrequency: String?
    let applicationFrequency: String?
    let tiers: [ProductRateTierModel]?
    let additionalValue: String?
    let additionalInfo: String?
    let additionalInfoUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case type = "depositRateType"
        case rate = "rate"
        case calculationFrequency = "calculationFrequency"
        case applicationFrequency = "applicationFrequency"
        case tiers = "tiers"
        case additionalValue = "additionalValue"
        case additionalInfo = "additionalInfo"
        case additionalInfoUrl = "additionalInfoUri"
    }
}
