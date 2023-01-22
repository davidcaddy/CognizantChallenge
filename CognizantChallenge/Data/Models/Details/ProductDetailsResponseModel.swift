//
//  ProductDetailsResponse.swift
//  CognizantChallenge
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

struct ProductDetailsResponseModel: Decodable {
    
    private struct DataModel: Decodable {
        let features: [ProductFeatureModel]?
        let bundles: [ProductBundleModel]?
        let eligibility: [ProductEligibilityModel]?
        let fees: [ProductFeeModel]?
        let depositRates: [ProductRateDepositModel]?
    }
    
    let product: ProductModel
    let bundles: [ProductBundleModel]?
    let features: [ProductFeatureModel]?
    let eligibility: [ProductEligibilityModel]?
    let fees: [ProductFeeModel]?
    let depositRates: [ProductRateDepositModel]?
    let links: LinksModel
    let meta: MetaModel?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case links = "links"
        case meta = "meta"
    }
    
    public init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)

        self.product = try keyedContainer.decode(ProductModel.self, forKey: .data)
        let data = try keyedContainer.decode(DataModel.self, forKey: .data)
        self.bundles = data.bundles
        self.features = data.features
        self.eligibility = data.eligibility
        self.fees = data.fees
        self.depositRates = data.depositRates
        self.links = try keyedContainer.decode(LinksModel.self, forKey: .links)
        self.meta = try? keyedContainer.decode(MetaModel.self, forKey: .meta)
    }
}
