
//
//  MarvelCharcters.swift
//  Marvel
//
//  Created by prog_zidane on 12/2/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import Foundation
import UIKit
struct MarvelCharctersModel : Codable {
    let data : CharactersData?
    let status : String?
    let attributionText : String?
    let code : Int?
    let copyright : String?
    let attributionHTML : String?
    let etag : String?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
        case status = "status"
        case attributionText = "attributionText"
        case code = "code"
        case copyright = "copyright"
        case attributionHTML = "attributionHTML"
        case etag = "etag"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(CharactersData.self, forKey: .data)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        attributionText = try values.decodeIfPresent(String.self, forKey: .attributionText)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        copyright = try values.decodeIfPresent(String.self, forKey: .copyright)
        attributionHTML = try values.decodeIfPresent(String.self, forKey: .attributionHTML)
        etag = try values.decodeIfPresent(String.self, forKey: .etag)
    }
    
}
struct CharactersData : Codable {
    let offset : Int?
    let limit : Int?
    let charcters : [MarvelCharacter]?
    let count : Int?
    let total : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case offset = "offset"
        case limit = "limit"
        case charcters = "results"
        case count = "count"
        case total = "total"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        offset = try values.decodeIfPresent(Int.self, forKey: .offset)
        limit = try values.decodeIfPresent(Int.self, forKey: .limit)
        charcters = try values.decodeIfPresent([MarvelCharacter].self, forKey: .charcters)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }
    
}

struct MarvelCharacter : Codable,Hashable {
    static func == (lhs: MarvelCharacter, rhs: MarvelCharacter) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.thumbnail?.url == rhs.thumbnail?.url &&
            lhs.description == rhs.description
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id?.hashValue)
        hasher.combine(name?.hashValue)
    }
    let events : CharcterSection?
    let series : CharcterSection?
    let comics : CharcterSection?
    let resourceURI : String?
    let urls : [Urls]?
    let name : String?
    let thumbnail : Thumbnail?
    let stories : CharcterSection?
    let id : Int?
    let description : String?
    let modified : String?
    var image:UIImage?
    
    enum CodingKeys: String, CodingKey {
        
        case events = "events"
        case series = "series"
        case comics = "comics"
        case resourceURI = "resourceURI"
        case urls = "urls"
        case name = "name"
        case thumbnail = "thumbnail"
        case stories = "stories"
        case id = "id"
        case description = "description"
        case modified = "modified"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        events = try values.decodeIfPresent(CharcterSection.self, forKey: .events)
        series = try values.decodeIfPresent(CharcterSection.self, forKey: .series)
        comics = try values.decodeIfPresent(CharcterSection.self, forKey: .comics)
        resourceURI = try values.decodeIfPresent(String.self, forKey: .resourceURI)
        urls = try values.decodeIfPresent([Urls].self, forKey: .urls)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        thumbnail = try values.decodeIfPresent(Thumbnail.self, forKey: .thumbnail)
        stories = try values.decodeIfPresent(CharcterSection.self, forKey: .stories)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        modified = try values.decodeIfPresent(String.self, forKey: .modified)
    }
    
}

struct Items : Codable {
    let type : String?
    let resourceURI : String?
    let name : String?
    
    var url :String?{
        let path = self.resourceURI?.subString(from: 0, to: (self.resourceURI!.count) - 3)
        let imageExtension = self.resourceURI?.subString(from: (self.resourceURI!.count) - 3, to: (self.resourceURI!.count) )
        print(path! + "." + imageExtension!)
        return  path! + "." + imageExtension!
    }
    var id :Int?{
        let id = String((resourceURI?.split(separator: "/").last)!)
        return Int(id)
    }
    enum CodingKeys: String, CodingKey {
        
        case type = "type"
        case resourceURI = "resourceURI"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        resourceURI = try values.decodeIfPresent(String.self, forKey: .resourceURI)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
    
}

struct CharcterSection : Codable {
    let returned : Int?
    let items : [Items]?
    let collectionURI : String?
    let available : Int?
    enum CodingKeys: String, CodingKey {
        
        case returned = "returned"
        case items = "items"
        case collectionURI = "collectionURI"
        case available = "available"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        returned = try values.decodeIfPresent(Int.self, forKey: .returned)
        items = try values.decodeIfPresent([Items].self, forKey: .items)
        collectionURI = try values.decodeIfPresent(String.self, forKey: .collectionURI)
        available = try values.decodeIfPresent(Int.self, forKey: .available)
    }
    
}

struct Thumbnail : Codable {
    let path : String?
    let x_tension : String?
    var url: String {
        get { return path! + "/standard_xlarge." + x_tension! }
    }
    enum CodingKeys: String, CodingKey {
        case path = "path"
        case x_tension = "extension"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        x_tension = try values.decodeIfPresent(String.self, forKey: .x_tension)
    }
    
}
struct Urls : Codable {
    let type : String?
    let url : String?
    enum CodingKeys: String, CodingKey {
        
        case type = "type"
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }
    
}


//set, get & remove Marvel Chache Characters in cache
struct MarvelCharactersChacheManager{
    static let key = "responseChache"
    static func chacheValue(_ value: [MarvelCharacter]!) {
        DispatchQueue.main.async {
            do {
                UserDefaults.standard.set(try PropertyListEncoder().encode(value), forKey: key)
            }catch{
                print("save failed",error)
            }
        }
    }
    static func getChechedValue() -> [MarvelCharacter]? {
        var marvelCharacters: [MarvelCharacter]!
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
                marvelCharacters = try? PropertyListDecoder().decode([MarvelCharacter].self, from: data)
            return marvelCharacters!
        } else {
            return nil
        }
        
    }
    static func removePreviousChache() {
        DispatchQueue.main.async {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}
