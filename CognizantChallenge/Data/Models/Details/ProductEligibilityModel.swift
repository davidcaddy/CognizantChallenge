//
//  ProductEligibilityModel.swift
//  CognizantChallenge
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

struct ProductEligibilityModel: Decodable {
    
    enum EligibilityType: String, Decodable {
        case business = "BUSINESS"
        case pensionRecipient = "PENSION_RECIPIENT"
        case minAge = "MIN_AGE"
        case maxAge = "MAX_AGE"
        case minInclome = "MIN_INCOME"
        case minTurnover = "MIN_TURNOVER"
        case staff = "STAFF"
        case student = "STUDENT"
        case employmentStatus = "EMPLOYMENT_STATUS"
        case residencyStatus = "RESIDENCY_STATUS"
        case naturalPerson = "NATURAL_PERSON"
        case introductory = "INTRODUCTORY"
        case other = "OTHER"
    }
    
    let type: EligibilityType
    let additionalValue: String?
    let additionalInfo: String?
    let additionalInfoUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case type = "eligibilityType"
        case additionalValue = "additionalValue"
        case additionalInfo = "additionalInfo"
        case additionalInfoUrl = "additionalInfoUri"
    }
}
