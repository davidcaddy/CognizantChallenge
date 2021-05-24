//
//  MetaModel.swift
//  Cognizant
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

struct MetaModel: Decodable {
    let records: Int?
    let pages: Int?
    
    enum CodingKeys: String, CodingKey {
        case records = "totalRecords"
        case pages = "totalPages"
    }
}
