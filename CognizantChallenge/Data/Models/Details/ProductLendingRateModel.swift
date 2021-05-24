//
//  ProductLendingRateModel.swift
//  CognizantChallenge
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

struct ProductLendingRateModel: Decodable {
    
    enum LoanPurpose: String, Decodable {
        case ownerOccupied = "OWNER_OCCUPIED"
        case investment = "INVESTMENT"
    }
    
    enum RepaymentType: String, Decodable {
        case interestOnly = "INTEREST_ONLY"
        case principalAndInterest = "PRINCIPAL_AND_INTEREST"
    }
    
    enum InterestPaymentDue: String, Decodable {
        case inArrears = "IN_ARREARS"
        case inAdvance = "IN_ADVANCE"
    }
    
    enum LendingRateType: String, Decodable {
        case fixed = "FIXED"
        case variable = "VARIABLE"
        case introductory = "INTRODUCTORY"
        case discount = "DISCOUNT"
        case penalty = "PENALTY"
        case floating = "FLOATING"
        case marketLinked = "MARKET_LINKED"
        case cashAdvance = "CASH_ADVANCE"
        case purchase = "PURCHASE"
        case bundleDiscountFixed = "BUNDLE_DISCOUNT_FIXED"
        case bundleDiscountVariable = "BUNDLE_DISCOUNT_VARIABLE"
    }
    
    let type: LendingRateType
    let rate: String
    let comparisonRate: String?
    let calculationFrequency: String?
    let applicationFrequency: String?
    let interestPaymentDue: InterestPaymentDue?
    let repaymentType: RepaymentType?
    let loanPurpose: LoanPurpose?
    let tiers: [ProductRateTierModel]?
    let additionalValue: String?
    let additionalInfo: String?
    let additionalInfoUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case type = "lendingRateType"
        case rate = "rate"
        case comparisonRate = "comparisonRate"
        case calculationFrequency = "calculationFrequency"
        case applicationFrequency = "applicationFrequency"
        case interestPaymentDue = "interestPaymentDue"
        case repaymentType = "repaymentType"
        case loanPurpose = "loanPurpose"
        case tiers = "tiers"
        case additionalValue = "additionalValue"
        case additionalInfo = "additionalInfo"
        case additionalInfoUrl = "additionalInfoUri"
    }
}
