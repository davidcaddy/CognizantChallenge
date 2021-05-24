//
//  ProductConstraintModel.swift
//  CognizantChallenge
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

struct ProductConstraintModel: Decodable {
    
    enum ConstraintType: String, Decodable {
        case minBalance = "MIN_BALANCE"
        case maxBalance = "MAX_BALANCE"
        case openingBalance = "OPENING_BALANCE"
        case maxLimit = "MAX_LIMIT"
        case minLimit = "MIN_LIMIT"
    }
    
    let type: ConstraintType
    let additionalValue: String?
    let additionalInfo: String?
    let additionalInfoUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case type = "constraintType"
        case additionalValue = "additionalValue"
        case additionalInfo = "additionalInfo"
        case additionalInfoUrl = "additionalInfoUri"
    }
}
