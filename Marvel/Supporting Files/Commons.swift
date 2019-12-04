//
//  Commons.swift
//  Marvel
//
//  Created by prog_zidane on 12/1/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import Foundation
import UIKit
import GSMessages
import Alamofire

struct  Commons {
   static let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
   static let apiPublicKey = "1951bc8fc24c16592930f688c6df1581"
   static let apiPrivateKey = "76cb8d0bd88b49abe3e4d049e6064518062f998c"
   static let baseUrl = "https://gateway.marvel.com:443/v1/public/"
   static let characterUrl = baseUrl + "characters"
   static let comicsUrl = baseUrl + "comics"
   static let seriesUrl = baseUrl + "series"
   static let eventsUrl = baseUrl + "events"
   static let storiesUrl = baseUrl + "stories"
    
    
    //MARK:- Refactoring paramters url arguments
    static func refactoringParamtersAndUrls(name:String?,page:Int,resourceType:ResourceType?)->(Parameters,String){
        
        let publickey = Commons.apiPublicKey;
        let privatekey = Commons.apiPrivateKey;
        let limit = 10
        print("offset count  ",page)
        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = "\(timestamp)\(privatekey)\(publickey)".md5
        if resourceType != nil {
            switch resourceType! {
            case ResourceType.comics(let id):
                print("comicn",id)
                return  ([
                    "ts":timestamp,
                    "apikey": publickey,
                    "hash": hash,
                    
                    ],Commons.comicsUrl + "/\(id)")
            case ResourceType.series(let id):
                return ( [
                    "ts":timestamp,
                    "apikey": publickey,
                    "hash": hash,
                    ],Commons.seriesUrl + "/\(id)")
            case ResourceType.stories(let id):
                return ( [
                    "ts":timestamp,
                    "apikey": publickey,
                    "hash": hash,
                    ],Commons.storiesUrl + "/\(id)")
            case ResourceType.events(let id):
                return  ([
                    "ts":timestamp,
                    "apikey": publickey,
                    "hash": hash,
                    ],Commons.eventsUrl + "/\(id)")
            }
            
        }
        return  name == "" ? ([
            "ts":timestamp,
            "apikey": publickey,
            "hash": hash,
            "limit": limit,
            "offset":page
            ],Commons.characterUrl) : ([
                "ts":timestamp,
                "apikey": publickey,
                "hash": hash,
                "limit": limit,
                "nameStartsWith":name!,
                "offset": page
                ],Commons.characterUrl)
    }
    
    //MARK:- Show Notification Message
    static func showNotificationMessage(message: String? =
        nil,type:GSMessageType?,view:UIView){
        
        switch type {
        case .error?:
            view.showMessage(message ?? "" , type: GSMessageType.error)
        case .success?:
            view.showMessage(message ?? "" , type: GSMessageType.success)
        case .warning?:
            view.showMessage(message ?? "" , type: GSMessageType.warning)
        default:
            break
        }
        
    }
}
//alter keys
//apiKey : b764ea16460209cd4d6eeab3a5955965
//private : a541787e669a846a7514378ea62c68910db84b1b
