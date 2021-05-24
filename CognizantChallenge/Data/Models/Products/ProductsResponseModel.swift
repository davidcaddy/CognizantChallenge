//
//  ResponseModel.swift
//  Cognizant
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

struct ProductsResponseModel: Decodable {
    
    private struct DataModel: Decodable {
        let products: [ProductModel]
    }
    
    let products: [ProductModel]
    let links: LinksModel
    let meta: MetaModel
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case links = "links"
        case meta = "meta"
    }
    
    public init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)

        let data = try keyedContainer.decode(DataModel.self, forKey: .data)
        self.products = data.products
        self.links = try keyedContainer.decode(LinksModel.self, forKey: .links)
        self.meta = try keyedContainer.decode(MetaModel.self, forKey: .meta)
    }
}
