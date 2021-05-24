//
//  ProductFeeModel.swift
//  CognizantChallenge
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

struct ProductFeeModel: Decodable {
    
    struct Discount: Decodable {
        
        enum DiscountType: String, Decodable {
            case balance = "BALANCE"
            case deposits = "DEPOSITS"
            case payments = "PAYMENTS"
            case feeCap = "FEE_CAP"
            case eligibilityOnly = "ELIGIBILITY_ONLY"
        }
        
        enum CodingKeys: String, CodingKey {
            case name = "name"
            case type = "discountType"
            case amount = "amount"
            case balanceRate = "balanceRate"
            case transactionRate = "transactionRate"
            case accruedRate = "accruedRate"
            case feeRate = "feeRate"
            case eligibility = "eligibility"
            case additionalValue = "additionalValue"
            case additionalInfo = "additionalInfo"
            case additionalInfoUrl = "additionalInfoUrl"
        }
        
        let name: String
        let type: DiscountType
        let amount: String
        let balanceRate: String?
        let transactionRate: String?
        let accruedRate: String?
        let feeRate: String?
        let eligibility: [ProductEligibilityModel]?
        let additionalValue: String?
        let additionalInfo: String?
        let additionalInfoUrl: URL?
    }
    
    enum FeeType: String, Decodable {
        case periodic = "PERIODIC"
        case transaction = "TRANSACTION"
        case withdrawal = "WITHDRAWAL"
        case deposit = "DEPOSIT"
        case payment = "PAYMENT"
        case purchase = "PURCHASE"
        case event = "EVENT"
        case upfront = "UPFRONT"
        case exit = "EXIT"
    }
    
    let name: String
    let type: FeeType
    let amount: String
    let balanceRate: String?
    let transactionRate: String?
    let accruedRate: String?
    let accrualFrequency: String?
    let currency: String?
    let discounts: [Discount]?
    let additionalValue: String?
    let additionalInfo: String?
    let additionalInfoUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case type = "feeType"
        case amount = "amount"
        case balanceRate = "balanceRate"
        case transactionRate = "transactionRate"
        case accruedRate = "accruedRate"
        case accrualFrequency = "accrualFrequency"
        case currency = "currency"
        case discounts = "discounts"
        case additionalValue = "additionalValue"
        case additionalInfo = "additionalInfo"
        case additionalInfoUrl = "additionalInfoUri"
    }
}
