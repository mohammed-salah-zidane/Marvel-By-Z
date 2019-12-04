//
//  Router.swift
//  Marvel
//
//  Created by prog_zidane on 12/2/19.
//  Copyright © 2019 prog_zidane. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum ResourceType{
    case comics(id:Int)
    case stories(id:Int)
    case series(id:Int)
    case events(id:Int)
}
class Router{
    
    static let shared = Router()
    private init(){
        
    }
    var request:DataRequest?
    
    //MARK:- Fetch search result from the API
    func fetchCharacters(name:String = "",offset:Int = 0, _ completion:@escaping(_ status:Bool, _ charactersData:CharactersData?)->()){
        /* 1 - API method arguments */
        let paramters = refactoringParamtersAndUrls(name: name, page: offset, resourceType: nil )
        /* 2 - API request */
        request = Alamofire.SessionManager.default.request(paramters.1, method: .get,parameters: paramters.0, encoding: URLEncoding.default)
            .responseJSON { (response) in
            
                //print(JSON(response.data))
                switch response.result{
                case  .failure: break
                   // completion(false,nil)
                case .success:
                    print(JSON(response.data))
                    let decoder = JSONDecoder()
                    do {
                        //decode json with codable protocol
                        let responseModel = try decoder.decode(MarvelCharctersModel.self, from: response.data!)
                        //safe unwraping photo model with guard
                        guard let charctersData = responseModel.data,responseModel.code == 200 else {
                            completion(false,nil)
                            return
                        }
                        //assign local images
                        //self.checkIfLocalImageExist(in: CharactersData)
                        
                        //return with success and photo model
                        completion(true,charctersData)
                        return
                    }catch{
                        print(error.localizedDescription)
                        //completion(false,nil)
                    }
                }
                
        }
        
    }
    
    //MARK:- Fetch resource Image url result from the API
    func fetchImageUrl(resourceType:ResourceType?,_ completion:@escaping(_ status:Bool, _ url:String?)->()){
        /* 1 - API method arguments */
        let paramters = refactoringParamtersAndUrls(name: nil, page: 0, resourceType: resourceType)
        /* 2 - API request */
        request = Alamofire.SessionManager.default.request(paramters.1, method: .get,parameters: paramters.0, encoding: URLEncoding.default)
            .responseJSON { (response) in
                print(JSON(response.data))
                switch response.result{
                case  .failure:
                    completion(false,nil)
                case .success:
                    let decoder = JSONDecoder()
                    do {
                        //decode json with codable protocol
                        let responseModel = try decoder.decode(ItemImage.self, from: response.data!)
                        //safe unwraping photo model with guard
                        guard let resourceData = responseModel.data,responseModel.code == 200 else {
                            completion(false,nil)
                            return
                        }
                        guard let url = resourceData.results?.first?.thumbnail?.url else {
                            completion(false,nil)
                            return
                        }
                        print("urllls",resourceData.results?.first?.thumbnail?.url)
                        //assign local images
                        //self.checkIfLocalImageExist(in: CharactersData)
                        
                        //return with success and photo model
                        completion(true,url)
                        return
                    }catch{
                        print(error.localizedDescription)
                        completion(false,nil)
                    }
                }
                
        }


    }
    
    //MARK: - Cancel all previous tasks
    func cancelCurrentTask(){
        if request != nil {
            request?.cancel()
        }
        
    }
    
    //MARK:- Refactoring paramters url arguments
    func refactoringParamtersAndUrls(name:String?,page:Int,resourceType:ResourceType?)->(Parameters,String){
        
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


}
