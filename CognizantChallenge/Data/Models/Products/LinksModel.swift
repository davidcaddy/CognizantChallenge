//
//  LinksModel.swift
//  Cognizant
//
//  Created by Dave Caddy on 24/5/21.
//

import Foundation

struct LinksModel: Decodable {
    let current: URL
    let first: URL?
    let previous: URL?
    let next: URL?
    let last: URL?
    
    enum CodingKeys: String, CodingKey {
        case current = "self"
        case first = "first"
        case previous = "prev"
        case next = "next"
        case last = "last"
    }
}
