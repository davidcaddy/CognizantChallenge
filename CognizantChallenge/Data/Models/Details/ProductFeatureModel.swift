//
//  ProductFeatureModel.swift
//  CognizantChallenge
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

struct ProductFeatureModel: Decodable {
    
    enum FeatureType: String, Decodable {
        case cardAccess = "CARD_ACCESS"
        case additionalCards = "ADDITIONAL_CARDS"
        case unlimtedTxns = "UNLIMITED_TXNS"
        case freeTxns = "FREE_TXNS"
        case freeTxnsAllowance = "FREE_TXNS_ALLOWANCE"
        case loyaltyProgram = "LOYALTY_PROGRAM"
        case offset = "OFFSET"
        case overdraft = "OVERDRAFT"
        case redraw = "REDRAW"
        case insurance = "INSURANCE"
        case balanceTransfers = "BALANCE_TRANSFERS"
        case interestFree = "INTEREST_FREE"
        case interestFreeTransfers = "INTEREST_FREE_TRANSFERS"
        case digitalWallet = "DIGITAL_WALLET"
        case digitalBaanking = "DIGITAL_BANKING"
        case nppPayid = "NPP_PAYID"
        case nppEnabled = "NPP_ENABLED"
        case donateInterest = "DONATE_INTEREST"
        case billPayment = "BILL_PAYMENT"
        case complementaryProductDiscounts = "COMPLEMENTARY_PRODUCT_DISCOUNTS"
        case bonusRewards = "BONUS_REWARDS"
        case notifications = "NOTIFICATIONS"
        case other = "OTHER"
        
        var displayString: String {
            return self.rawValue.replacingOccurrences(of: "_", with: " ").capitalized
        }
    }
    
    let type: FeatureType
    let additionalValue: String?
    let additionalInfo: String?
    let additionalInfoUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case type = "featureType"
        case additionalValue = "additionalValue"
        case additionalInfo = "additionalInfo"
        case additionalInfoUrl = "additionalInfoUri"
    }
}
