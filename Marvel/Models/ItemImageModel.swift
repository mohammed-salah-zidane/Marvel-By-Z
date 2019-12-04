//
//  ItemImageModel.swift
//  Marvel
//
//  Created by prog_zidane on 12/3/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import Foundation
struct ItemImage : Codable {
    
    let code : Int?
    let data : Datum?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        data = try values.decodeIfPresent(Datum.self, forKey: .data)
    }
    
}
struct Datum : Codable {
    
    let results : [ResourceData]?
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([ResourceData].self, forKey: .results)
    }
    
}
struct ResourceData : Codable {
    
    let id : Int?
    let thumbnail : Thumbnail?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case thumbnail = "thumbnail"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        thumbnail = try values.decodeIfPresent(Thumbnail.self, forKey: .thumbnail)
    }
    
}
